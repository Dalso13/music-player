import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:music_player/data/mapper/mediaItem_mapper.dart';

// 리포지터리
import '../../data/repository/audio_repository_impl.dart';
import '../../domain/repository/song_repository.dart';

// use_case
import '../../domain/use_case/audio_player_stream/interface/audio_player_state_stream.dart';
import '../../domain/use_case/button_change/interface/repeat_change.dart';
import '../../domain/use_case/button_change/interface/shuffle_change.dart';
import '../../domain/use_case/music_controller/interface/music_controller.dart';
import '../../domain/use_case/music_controller/interface/seek_controller.dart';
import '../../domain/use_case/play_list/interface/click_play_list_song.dart';
import '../../domain/use_case/play_list/interface/play_list_setting.dart';
import '../../domain/repository/audio_repository.dart';

// state
import 'state/main_state.dart';
import 'state/progress_bar_state.dart';






class MainViewModel extends ChangeNotifier {
  final SongRepository _songRepository;
  MainState _mainState = const MainState();
  final AudioRepository _audioRepository = AudioRepositoryImpl();
  ProgressBarState _progressNotifier = const ProgressBarState();

  //background-service
  final AudioHandler _audioHandler;

  // // use_case
  final PlayListSetting _setMusicList;
  final MusicController _playController;
  final MusicController _previousPlayController;
  final MusicController _stopController;
  final MusicController _nextPlayController;
  final RepeatChange _repeatChange;
  final ShuffleChange _shuffleChange;
  final ClickPlayListSong _clickPlayListSong;
  final SeekController _seekController;
  final AudioPlayerStateStream _audioPlayerStateStream;
  // use_case

  MainViewModel({
    required AudioHandler audioHandler,
    required SongRepository songRepository,
    required PlayListSetting setMusicList,
    required MusicController playController,
    required MusicController previousPlayController,
    required MusicController stopController,
    required MusicController nextPlayController,
    required RepeatChange repeatChange,
    required ShuffleChange shuffleChange,
    required ClickPlayListSong clickPlayListSong,
    required SeekController seekController,
    required AudioPlayerStateStream audioPlayerPositionStream,
  })  : _songRepository = songRepository,
        _setMusicList = setMusicList,
        _playController = playController,
        _previousPlayController = previousPlayController,
        _stopController = stopController,
        _nextPlayController = nextPlayController,
        _repeatChange = repeatChange,
        _shuffleChange = shuffleChange,
        _clickPlayListSong = clickPlayListSong,
        _seekController = seekController,
        _audioPlayerStateStream = audioPlayerPositionStream,
        _audioHandler = audioHandler;

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

    await _setMusicList.execute(
        songList: songList.getRange(index, songList.length).toList());
    clickPlayButton();
    notifyListeners();
  }

  // TODO: 메인 화면 서플 버튼 누를시
  void shufflePlayList() async {
    final songList = mainState.songList.toList();
    songList.shuffle();
    await _setMusicList.execute(songList: songList);
    clickPlayButton();
    notifyListeners();
  }

  // TODO : 재생 목록 바뀔때마다 플레이리스트 갱신
  void _listenToChangesInPlaylist() {
    _audioHandler.queue.listen((playlist) {
      if (playlist.isEmpty) return;
      final newList = playlist.map((item) => item.toAudioModel()).toList();
      _mainState = _mainState.copyWith(playList: newList);
      notifyListeners();
    });
  }
  
  // TODO :  재생 상태 조작
  void _listenToPlaybackState() {
    _audioHandler.playbackState.listen((playbackState) {
      final buttonState = _audioPlayerStateStream.execute(playbackState: playbackState);
      _mainState = _mainState.copyWith(buttonState: buttonState);
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
      if (playbackState.queueIndex != null && mainState.playList.isNotEmpty) {
        _mainState =
            _mainState.copyWith(currentIndex: playbackState.queueIndex!);
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
  void stopMusic() => _stopController.execute();

  // TODO: 재생 버튼 누르기
  void clickPlayButton() => _playController.execute();

  // TODO: 프로그레스 바 클릭 이벤트
  void seek(Duration position) {
    _seekController.execute(position: position);
    notifyListeners();
  }

  // TODO: 다음 곡
  void nextPlay() {
    _nextPlayController.execute();
    notifyListeners();
  }

  // TODO: 이전 곡
  void previousPlay() {
    _previousPlayController.execute();
    notifyListeners();
  }

  // TODO : 플레이 리스트 곡 클릭
  void clickPlayListSong({required int idx}) async {
    _clickPlayListSong.execute(idx: idx);
  }

  // TODO: 반복 재생 버튼 클릭
  void repeatModeChange() {
    final repeatMode = _repeatChange.execute(_mainState.repeatState);
    _mainState = _mainState.copyWith(repeatState: repeatMode);
    notifyListeners();
  }

  // TODO: 서플 여부 버튼 클릭
  void shuffleModeChange() async {
    final enable = await _shuffleChange.execute(
        isShuffleModeEnabled: _mainState.isShuffleModeEnabled);
    _mainState = _mainState.copyWith(isShuffleModeEnabled: enable);
    notifyListeners();
  }

  @override
  void dispose() {
    _audioRepository.audioPlayer.dispose();
    super.dispose();
  }
}
