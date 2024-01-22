import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/core/button_state.dart';
import 'package:music_player/core/repeat_state.dart';
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

  ProgressBarState _progressNotifier = ProgressBarState(
    current: Duration.zero,
    buffered: Duration.zero,
    total: Duration.zero,
  );

  MainViewModel({
    required SongRepository songRepository,
  })  : _songRepository = songRepository,
        _audioQuery = songRepository.audioQuery;

  ProgressBarState get progressNotifier => _progressNotifier;
  MainState get mainState => _mainState;
  List<SongModel> get songList => _songList;
  OnAudioQuery get audioQuery => _audioQuery;
  List<SongModel> get playList => _playList;


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
        _mainState = _mainState.copyWith(
            buttonState : ButtonState.loading
        );
      } else if (!isPlaying) {
        _mainState = _mainState.copyWith(
            buttonState : ButtonState.paused
        );
      } else if (processingState != ProcessingState.completed) {
        _mainState = _mainState.copyWith(
            buttonState : ButtonState.playing
        );
      } else {
        _audioPlayer.seek(Duration.zero);
        _audioPlayer.pause();
      }
      notifyListeners();
    });
    audioPlayerPositionStream();

     _audioPlayer.sequenceStateStream.listen((sequenceState) {
      if (sequenceState == null) return;
      _mainState = _mainState.copyWith(
          shuffleIndices : sequenceState.shuffleIndices,
          currentIndex : sequenceState.currentIndex,
          isShuffleModeEnabled : sequenceState. shuffleModeEnabled
      );
      notifyListeners();
    });

    notifyListeners();
  }

  // TODO: 리스트에 곡 클릭시
  void playMusic({required int index}) async {
    final playlist = ConcatenatingAudioSource(
        children:_songList.getRange(index, _songList.length).map((e) {
          return AudioSource.file(e.getMap['_data']);
        }).toList()
    );
    await _audioPlayer.setAudioSource(playlist,initialPosition: Duration.zero);

    clickPlayButton();
    notifyListeners();
  }

  // TODO: 메인 화면 서플 버튼 누를시
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
    notifyListeners();
  }

  // TODO: 음악 멈추기
  void stopMusic() async {
    if (_audioPlayer.playing) {
      await _audioPlayer.pause();
    }
    notifyListeners();
  }

  // TODO: 재생 버튼 누르기
  void clickPlayButton() async {
    await _audioPlayer.play();
  }

  // TODO: 프로그레스 바 클릭 이벤트
  void seek(Duration position) {
    _audioPlayer.seek(position);
  }

  // TODO: 다음 곡
  void nextPlay() async {
    await _audioPlayer.seekToNext();
  }

  // TODO: 이전 곡
  void previousPlay() async {
    await _audioPlayer.seekToPrevious();
  }

  // TODO: 반복 재생 버튼 클릭
  void repeatModeChange() {
    switch(_mainState.repeatState){
      case RepeatState.off:
        _mainState = _mainState.copyWith(
            repeatState : RepeatState.repeatPlaylist
        );
        _audioPlayer.setLoopMode(LoopMode.all);
      case RepeatState.repeatPlaylist:
        _mainState = _mainState.copyWith(
            repeatState : RepeatState.repeatSong
        );
        _audioPlayer.setLoopMode(LoopMode.one);
      case RepeatState.repeatSong:
        _mainState = _mainState.copyWith(
            repeatState : RepeatState.off
        );
        _audioPlayer.setLoopMode(LoopMode.off);
    }
    notifyListeners();
  }

  // TODO: 서플 여부 버튼 클릭
  void shuffleModeChange() async {
    await _audioPlayer.setShuffleModeEnabled(!mainState.isShuffleModeEnabled);
    if (mainState.isShuffleModeEnabled) {
      await _audioPlayer.shuffle();
    }
    notifyListeners();
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


  void dispose() {
    _audioPlayer.dispose();
  }
}
