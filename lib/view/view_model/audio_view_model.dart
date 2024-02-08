import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:pristine_sound/data/mapper/media_item_mapper.dart';
// 리포지터리
import '../../domain/model/audio_model.dart';
import '../../domain/repository/song_repository.dart';

// use_case
import '../../domain/use_case/audio_player_stream/interface/audio_player_state_stream.dart';
import '../../domain/use_case/audio_player_stream/interface/dispose_controller.dart';
import '../../domain/use_case/audio_player_stream/interface/get_current_index.dart';
import '../../domain/use_case/button_change/interface/repeat_change.dart';
import '../../domain/use_case/button_change/interface/shuffle_change.dart';
import '../../domain/use_case/color/interface/imag_base_color.dart';
import '../../domain/use_case/music_controller/interface/music_controller.dart';
import '../../domain/use_case/music_controller/interface/seek_controller.dart';
import '../../domain/use_case/play_list/interface/add_song.dart';
import '../../domain/use_case/play_list/interface/click_play_list_song.dart';
import '../../domain/use_case/play_list/interface/insert_song.dart';
import '../../domain/use_case/play_list/interface/play_list_setting.dart';

// state
import '../../domain/use_case/sleep_timer/interface/sleep_timer_pause.dart';
import '../../domain/use_case/sleep_timer/interface/sleep_timer_start.dart';
import 'state/audio_state.dart';
import 'state/progress_bar_state.dart';






class AudioViewModel extends ChangeNotifier {
  final SongRepository _songRepository;
  AudioState _audioState = const AudioState();
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
  final DisposeController _disposeController;
  final ImageBaseColor _imageBaseColor;
  final InsertSong _insertSong;
  final AddSong _addSong;
  final GetCurrentIndex _getCurrentIndex;
  final SleepTimerStart _sleepTimerStart;
  final SleepTimerPause _sleepTimerPause;
  // use_case

  AudioViewModel({
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
    required DisposeController disposeController,
    required ImageBaseColor imageBaseColor,
    required InsertSong insertSong,
    required AddSong addSong,
    required GetCurrentIndex getCurrentIndex,
    required SleepTimerStart sleepTimerStart,
    required SleepTimerPause sleepTimerPause,
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
        _disposeController = disposeController,
        _imageBaseColor = imageBaseColor,
        _insertSong = insertSong,
        _addSong = addSong,
        _getCurrentIndex = getCurrentIndex,
        _sleepTimerStart = sleepTimerStart,
        _sleepTimerPause = sleepTimerPause,
        _audioHandler = audioHandler;

  ProgressBarState get progressNotifier => _progressNotifier;

  AudioState get state => _audioState;

  void init() async {
    _audioState = _audioState.copyWith(isLoading: true);
    notifyListeners();
    _audioState =
        _audioState.copyWith(songList: await _songRepository.getAudioSource());
    _audioState = _audioState.copyWith(isLoading: false);

    _listenToChangesInPlaylist();
    _listenToPlaybackState();
    _listenToCurrentPosition();
    _listenToBufferedPosition();
    _listenToTotalDuration();

    notifyListeners();
  }

  // TODO: 리스트에 곡 클릭시
  void playMusic({required int index}) async {
    _audioState = _audioState.copyWith(isShuffleModeEnabled: false);
    await _setMusicList.execute(songList: state.songList.toList(), index: index);
    clickPlayButton();
    notifyListeners();
  }
  // TODO: 커스텀 플레이 리스트 곡 재생
  void customPlayListPlayMusic({required bool isShuffle, required List<AudioModel> list}) async {
    if (list.isEmpty) return;
    _audioState = _audioState.copyWith(isShuffleModeEnabled: false);
    if (isShuffle) list.shuffle();
    await _setMusicList.execute(songList: list);
    clickPlayButton();
    notifyListeners();
  }

  // TODO: 메인 화면 서플 버튼 누를시
  void shufflePlayList() async {
    _audioState = _audioState.copyWith(isShuffleModeEnabled: false);
    final songList = state.songList.toList();
    songList.shuffle();
    await _setMusicList.execute(songList: songList);
    clickPlayButton();
    notifyListeners();
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
  void clickPlayListSong({required int idx}) {
    _clickPlayListSong.execute(idx: idx);
    notifyListeners();
  }

  // TODO: 반복 재생 버튼 클릭
  void repeatModeChange() {
    final repeatMode = _repeatChange.execute(_audioState.repeatState);
    _audioState = _audioState.copyWith(repeatState: repeatMode);
    notifyListeners();
  }

  // TODO: 서플 여부 버튼 클릭
  void shuffleModeChange() async {
    final enable = await _shuffleChange.execute(
        isShuffleModeEnabled: _audioState.isShuffleModeEnabled);
    _audioState = _audioState.copyWith(isShuffleModeEnabled: enable);
    int index = _audioState.playList.indexOf(_audioState.nowPlaySong);

    _audioState = _audioState.copyWith(
      currentIndex: index
    );
    notifyListeners();
  }

  // TODO: 재생 목록에 곡 추가
  void addSong({bool isCurrentPlaylistNext = false, required AudioModel song}) async {
    if (!isCurrentPlaylistNext || _audioState.playList.isEmpty){
      _addSong.execute(model: song);
    } else {
      _insertSong.execute(model: song, index: _audioState.currentIndex);
    }
    notifyListeners();
  }
  // TODO: 재생 목록에 곡 제거
  void removeSong({required int index}) async {

  }


  // 취침 타이머 조작
  void changeHour({required int hour}) {
    _audioState = _audioState.copyWith(hour: hour);
    notifyListeners();
  }
  void changeSecond({required int minutes}) {
    _audioState = _audioState.copyWith(minutes: minutes);
    notifyListeners();
  }
  void changeTimerEnabled({required bool isSleepTimerEnabled}) {
    _audioState = _audioState.copyWith(isSleepTimerEnabled:  isSleepTimerEnabled);
    saveSleepTimer();
    notifyListeners();
  }
  void _goSleepTimerStart() {
    int time = Duration(hours: _audioState.hour, minutes: _audioState.minutes).inMinutes;
    _sleepTimerStart.execute(minutes: time);
    notifyListeners();
  }
  void _goSleepTimerPause() {
    _sleepTimerPause.execute();
    notifyListeners();
  }
  void saveSleepTimer() {
    _audioState.isSleepTimerEnabled ? _goSleepTimerStart() : _goSleepTimerPause();
    notifyListeners();
  }



  // TODO : 재생 목록 바뀔때마다 플레이리스트 갱신
  void _listenToChangesInPlaylist() {
    _audioHandler.queue.listen((playlist) {
      if (playlist.isEmpty) return;
      final newList = playlist.map((item) => item.toAudioModel()).toList();
      _audioState = _audioState.copyWith(playList: newList);
      notifyListeners();
    });
    notifyListeners();
  }

  // TODO :  재생 상태 조작
  void _listenToPlaybackState() {
    _audioHandler.playbackState.listen((playbackState) {
      final buttonState = _audioPlayerStateStream.execute(playbackState: playbackState);
      _audioState = _audioState.copyWith(buttonState: buttonState);
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
      if (playbackState.queueIndex != null && state.playList.isNotEmpty) {
        int index = _getCurrentIndex.execute(index: playbackState.queueIndex!);
        _audioState =
            _audioState.copyWith(currentIndex: index);
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
      if (mediaItem == null) return;
      if (mediaItem.toAudioModel() == _audioState.nowPlaySong) return;
        _audioState = _audioState.copyWith(
          nowPlaySong: mediaItem.toAudioModel(),
        );
      _color(id: int.parse(mediaItem.id));
    });
  }

  void _color({required int id}) async {
    int color = await _imageBaseColor.execute(id: id);
   _audioState = _audioState.copyWith(
     artColor: color
   );
  }

  @override
  void dispose() {
    _disposeController.execute();
    super.dispose();
  }
}
