import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/core/button_state.dart';
import 'package:music_player/data/reposiotry/song_repository.dart';
import 'package:music_player/view/view_model/state/main_state.dart';
import 'package:music_player/view/view_model/state/progress_bar_state.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MainViewModel extends ChangeNotifier {
  final SongRepository _songRepository;
  MainState _mainState = MainState();
  late final AudioPlayer _audioPlayer;
  List<SongModel> _songList = [];
  List<SongModel> _playList = [];
  final OnAudioQuery _audioQuery;
  //bool _isShuffleModeEnabled = false;
  List<int> shuffleIndices = [];
  int currentIndex = 0;

  ButtonState _buttonState = ButtonState.paused;
  ProgressBarState _progressNotifier = ProgressBarState(
    current: Duration.zero,
    buffered: Duration.zero,
    total: Duration.zero,
  );


  MainViewModel({
    required SongRepository songRepository,
  })  : _songRepository = songRepository,
        _audioQuery = songRepository.audioQuery;

  ButtonState get buttonState => _buttonState;
  ProgressBarState get progressNotifier => _progressNotifier;
  MainState get mainState => _mainState;
  List<SongModel> get songList => _songList;
  OnAudioQuery get audioQuery => _audioQuery;
  //bool get isShuffleModeEnabled => _isShuffleModeEnabled;

  void init() async {
    _mainState = _mainState.copyWith(isLoading: true);
    notifyListeners();
    _songList = await _songRepository.getAudioSource();
    _mainState = _mainState.copyWith(isLoading: false);
    _audioPlayer = AudioPlayer();

    _audioPlayer.playerStateStream.listen((playerState) {
      final isPlaying = playerState.playing;
      final processingState = playerState.processingState;
      if (processingState == ProcessingState.loading ||
          processingState == ProcessingState.buffering) {
        _buttonState = ButtonState.loading;
      } else if (!isPlaying) {
        _buttonState = ButtonState.paused;
      } else if (processingState != ProcessingState.completed) {
        _buttonState = ButtonState.playing;
      } else {
        _audioPlayer.seek(Duration.zero);
        _audioPlayer.pause();
      }
      notifyListeners();
    });
    audioPlayerPositionStream();

     _audioPlayer.sequenceStateStream.listen((sequenceState) {
      if (sequenceState == null) return;
      shuffleIndices = sequenceState.shuffleIndices;
      currentIndex = sequenceState.currentIndex;
      notifyListeners();
    });

    notifyListeners();
  }


  void playMusic({required int index}) async {
    final playlist = ConcatenatingAudioSource(
        children:_songList.getRange(index, _songList.length).map((e) {
          return AudioSource.file(e.getMap['_data']);
        }).toList()
    );
    await _audioPlayer.setAudioSource(playlist,initialPosition: Duration.zero);

    _audioPlayer.play();
    notifyListeners();
  }

  void shufflePlayList() async {
    _playList = _songList.toList();
    _playList.shuffle();
    final playlist = ConcatenatingAudioSource(
        children:_playList.map((e) {
          return AudioSource.file(e.getMap['_data']);
        }).toList()
    );
    await _audioPlayer.setAudioSource(playlist,initialIndex: 0, initialPosition: Duration.zero);
    clickPlayButton();
  }

  void stopMusic() async {
    if (_audioPlayer.playing) {
      await _audioPlayer.pause();
    }
    notifyListeners();
  }

  void clickPlayButton() async {
    await _audioPlayer.play();
  }

  void seek(Duration position) {
    _audioPlayer.seek(position);
  }

  void nextPlay() async {
    await _audioPlayer.seekToNext();
  }
  void previousPlay() async {
    await _audioPlayer.seekToPrevious();
  }

  void dispose() {
    _audioPlayer.dispose();
  }



  // 프로그레스바 사용을 위한 메소드
  void audioPlayerPositionStream() {
    _audioPlayer.positionStream.listen((position) {
      final oldState = _progressNotifier;
      _progressNotifier = ProgressBarState(
        current: position,
        buffered: oldState.buffered,
        total: oldState.total,
      );
      notifyListeners();
    });

    _audioPlayer.bufferedPositionStream.listen((bufferedPosition) {
      final oldState = _progressNotifier;
      _progressNotifier = ProgressBarState(
        current: oldState.current,
        buffered: bufferedPosition,
        total: oldState.total,
      );
      notifyListeners();
    });

    _audioPlayer.durationStream.listen((totalDuration) {
      final oldState = _progressNotifier;
      _progressNotifier = ProgressBarState(
        current: oldState.current,
        buffered: oldState.buffered,
        total: totalDuration ?? Duration.zero,
      );
    });
  }
}
