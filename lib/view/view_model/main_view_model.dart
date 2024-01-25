import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:music_player/data/mapper/audio_model_mapper.dart';
import 'package:music_player/data/mapper/mediaItem_mapper.dart';

import '../../core/button_state.dart';
import '../../core/repeat_state.dart';
import '../../data/repository/audio_repository_impl.dart';
import '../../domain/repository/song_repository.dart';
import 'state/main_state.dart';
import 'state/progress_bar_state.dart';
import '../../domain/repository/audio_repository.dart';

class MainViewModel extends ChangeNotifier {
  final SongRepository _songRepository;
  MainState _mainState = const MainState();
  final AudioRepository _audioRepository = AudioRepositoryImpl();
  ProgressBarState _progressNotifier = const ProgressBarState();

  //background-service
  final AudioHandler _audioHandler;

  MainViewModel({
    required SongRepository songRepository,
    required AudioHandler audioHandler,
  })  : _songRepository = songRepository,
        _audioHandler = audioHandler;

  // // use_case
  // final PlayListSetting _setMusicList;
  // final ShufflePlayListSetting _shuffleMusicList;
  // final MusicController _playController;
  // final MusicController _previousPlayController;
  // final MusicController _stopController;
  // final MusicController _nextPlayController;
  // final RepeatChange _repeatChange;
  // final ShuffleChange _shuffleChange;
  // final ClickPlayListSong _clickPlayListSong;
  // final SeekController _seekController;
  // final AudioPlayerStateStream _audioPlayerStateStream;
  // // use_case
  //
  // MainViewModel({
  //   required SongRepository songRepository,
  //   required PlayListSetting setMusicList,
  //   required ShufflePlayListSetting shuffleMusicList,
  //   required MusicController playController,
  //   required MusicController previousPlayController,
  //   required MusicController stopController,
  //   required MusicController nextPlayController,
  //   required RepeatChange repeatChange,
  //   required ShuffleChange shuffleChange,
  //   required ClickPlayListSong clickPlayListSong,
  //   required SeekController seekController,
  //   required AudioPlayerStateStream audioPlayerPositionStream,
  // })  : _songRepository = songRepository,
  //       _setMusicList = setMusicList,
  //       _shuffleMusicList = shuffleMusicList,
  //       _playController = playController,
  //       _previousPlayController = previousPlayController,
  //       _stopController = stopController,
  //       _nextPlayController = nextPlayController,
  //       _repeatChange = repeatChange,
  //       _shuffleChange = shuffleChange,
  //       _clickPlayListSong = clickPlayListSong,
  //       _seekController = seekController,
  //       _audioPlayerStateStream = audioPlayerPositionStream;

  ProgressBarState get progressNotifier => _progressNotifier;

  MainState get mainState => _mainState;

  void init() async {
    _mainState = _mainState.copyWith(isLoading: true);
    notifyListeners();
    _mainState =
        _mainState.copyWith(songList: await _songRepository.getAudioSource());
    _mainState = _mainState.copyWith(isLoading: false);

    _listenToChangesInPlaylist();
    _listenToPlaybackState();
    _listenToCurrentPosition();
    _listenToBufferedPosition();
    _listenToTotalDuration();

    notifyListeners();
  }

  // TODO: 리스트에 곡 클릭시
  void playMusic({required int index}) async {
    final songList = mainState.songList.toList();

    final mediaItems = songList
        .getRange(index, songList.length)
        .map((song) => song.toMediaItem())
        .toList();
    await _audioHandler.addQueueItems(mediaItems);
    clickPlayButton();
    notifyListeners();
  }

  // TODO: 메인 화면 서플 버튼 누를시
  void shufflePlayList() async {
    final songList = mainState.songList.toList();
    songList.shuffle();
    final mediaItems = songList.map((song) => song.toMediaItem()).toList();
    await _audioHandler.addQueueItems(mediaItems);
    clickPlayButton();
    notifyListeners();
  }

  void _listenToChangesInPlaylist() {
    _audioHandler.queue.listen((playlist) {
      if (playlist.isEmpty) return;
      final newList = playlist.map((item) => item.toAudioModel()).toList();
      _mainState = _mainState.copyWith(playList: newList);
      notifyListeners();
    });
  }

  void _listenToPlaybackState() {
    _audioHandler.playbackState.listen((playbackState) {
      final isPlaying = playbackState.playing;
      final processingState = playbackState.processingState;
      if (processingState == AudioProcessingState.loading ||
          processingState == AudioProcessingState.buffering) {
        _mainState = _mainState.copyWith(buttonState: ButtonState.loading);
      } else if (!isPlaying) {
        _mainState = _mainState.copyWith(buttonState: ButtonState.paused);
      } else if (processingState != AudioProcessingState.completed) {
        _mainState = _mainState.copyWith(buttonState: ButtonState.playing);
      } else {
        _audioHandler.seek(Duration.zero);
        _audioHandler.pause();
      }
      notifyListeners();
    });
  }

  void _listenToCurrentPosition() {
    AudioService.position.listen((position) {
      _progressNotifier = _progressNotifier.copyWith(
        current: position,
      );
      notifyListeners();
    });
  }

  void _listenToBufferedPosition() {
    _audioHandler.playbackState.listen((playbackState) {
      _progressNotifier = _progressNotifier.copyWith(
        buffered: playbackState.bufferedPosition,
      );
      if (playbackState.queueIndex != null && mainState.playList.isNotEmpty){
        _mainState = _mainState.copyWith(
          currentIndex: playbackState.queueIndex!
        );

      }

      notifyListeners();
    });
  }

  void _listenToTotalDuration() {
    _audioHandler.mediaItem.listen((mediaItem) {
      _progressNotifier = _progressNotifier.copyWith(
        total: mediaItem?.duration ?? Duration.zero,
      );
      notifyListeners();
    });
  }

  // TODO: 음악 멈추기
  void stopMusic() => _audioHandler.pause();

  // TODO: 재생 버튼 누르기
  void clickPlayButton() => _audioHandler.play();

  // TODO: 프로그레스 바 클릭 이벤트
  void seek(Duration position) {
    _audioHandler.seek(position);
    notifyListeners();
  }

  // TODO: 다음 곡
  void nextPlay() {
    _audioHandler.skipToNext();
    notifyListeners();
  }

  // TODO: 이전 곡
  void previousPlay() {
    _audioHandler.skipToPrevious();
    notifyListeners();
  }

  // TODO : 플레이 리스트 곡 클릭
  void clickPlayListSong({required int idx}) async {
    _audioRepository.audioPlayer.seek(Duration.zero, index: idx);
  }

  // TODO: 반복 재생 버튼 클릭
  void repeatModeChange() {
    final repeatMode = _mainState.repeatState;
    switch (repeatMode) {
      case RepeatState.off:
        _audioHandler.setRepeatMode(AudioServiceRepeatMode.one);
        _mainState = _mainState.copyWith(repeatState: RepeatState.repeatSong);
        break;
      case RepeatState.repeatSong:
        _audioHandler.setRepeatMode(AudioServiceRepeatMode.all);
        _mainState =
            _mainState.copyWith(repeatState: RepeatState.repeatPlaylist);
        break;
      case RepeatState.repeatPlaylist:
        _audioHandler.setRepeatMode(AudioServiceRepeatMode.none);
        _mainState = _mainState.copyWith(repeatState: RepeatState.off);
        break;
    }
    notifyListeners();
  }

  // TODO: 서플 여부 버튼 클릭
  void shuffleModeChange() async {
    final enable = !_mainState.isShuffleModeEnabled;
    if (enable) {
      _audioHandler.setShuffleMode(AudioServiceShuffleMode.all);
    } else {
      _audioHandler.setShuffleMode(AudioServiceShuffleMode.none);
    }
    _mainState = _mainState.copyWith(isShuffleModeEnabled: enable);
    notifyListeners();
  }

  @override
  void dispose() {
    _audioRepository.audioPlayer.dispose();
    super.dispose();
  }
}
