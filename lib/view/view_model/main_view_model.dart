import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/data/reposiotry/song_repository.dart';
import 'package:music_player/view/view_model/state/main_state.dart';
import 'package:music_player/view/view_model/state/progress_bar_state.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MainViewModel extends ChangeNotifier {
  final SongRepository _songRepository;
  MainState _mainState = MainState();
  late final AudioPlayer _audioPlayer;
  List<SongModel> _songList = [];
  Stream<bool>? _isPlaying;
  final OnAudioQuery _audioQuery;
  final progressNotifier = ValueNotifier<ProgressBarState>(
    ProgressBarState(
      current: Duration.zero,
      buffered: Duration.zero,
      total: Duration.zero,
    ),
  );

  MainViewModel({
    required SongRepository songRepository,
  }) : _songRepository = songRepository, _audioQuery = songRepository.audioQuery;

  MainState get mainState => _mainState;

  List<SongModel> get songList => _songList;

  OnAudioQuery get audioQuery => _audioQuery;

  Stream<bool>? get isPlaying => _isPlaying;

  void init() async {
    _mainState = _mainState.copyWith(
        isLoading : true
    );
    notifyListeners();
    _songList = await _songRepository.getAudioSource();
    _mainState = _mainState.copyWith(
        isLoading : false
    );
    _audioPlayer = AudioPlayer();
    _isPlaying = _audioPlayer.playingStream;
    notifyListeners();

    _audioPlayer.positionStream.listen((position) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: position,
        buffered: oldState.buffered,
        total: oldState.total,
      );
    });

    _audioPlayer.bufferedPositionStream.listen((bufferedPosition) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: bufferedPosition,
        total: oldState.total,
      );
    });

    _audioPlayer.durationStream.listen((totalDuration) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: oldState.buffered,
        total: totalDuration ?? Duration.zero,
      );
    });
  }
  
  void playMusic({String? path}) async {
    if (path != null) {
      await _audioPlayer.setFilePath(path);
    }
      _audioPlayer.play();
      notifyListeners();
  }
  void stopMusic() async {
    if (_audioPlayer.playing){
      await _audioPlayer.pause();
    }
    notifyListeners();
  }

  void dispose() {
    _audioPlayer.dispose();
  }
  void seek(Duration position) {
    _audioPlayer.seek(position);
  }
}