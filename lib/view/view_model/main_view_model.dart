import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/core/button_state.dart';
import 'package:music_player/data/reposiotry/audio_repository.dart';
import 'package:music_player/data/reposiotry/song_repository.dart';
import 'package:music_player/domain/use_case/button_change/interface/shuffle_change.dart';
import 'package:music_player/domain/use_case/music_controller/impl/music_controller.dart';
import 'package:music_player/domain/use_case/play_list/interface/play_list_setting.dart';
import 'package:music_player/domain/use_case/play_list/interface/shuffle_play_list_setting.dart';
import 'package:music_player/view/view_model/state/main_state.dart';
import 'package:music_player/view/view_model/state/progress_bar_state.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../domain/use_case/button_change/interface/repeat_change.dart';

class MainViewModel extends ChangeNotifier {
  final SongRepository _songRepository;
  MainState _mainState = const MainState();
  final AudioRepository _audioRepository = AudioRepository();
  late final AudioPlayer _audioPlayer;
  List<SongModel> _songList = [];
  List<SongModel> _playList = [];
  final OnAudioQuery _audioQuery;

  // use_case
  final PlayListSetting _setMusicList;
  final ShufflePlayListSetting _shuffleMusicList;
  final MusicController _playController;
  final MusicController _previousPlayController;
  final MusicController _stopController;
  final MusicController _nextPlayController;
  final RepeatChange _repeatChange;
  final ShuffleChange _shuffleChange;
  // use_case

  ProgressBarState _progressNotifier = ProgressBarState(
    current: Duration.zero,
    buffered: Duration.zero,
    total: Duration.zero,
  );

  MainViewModel({
    required SongRepository songRepository,
    required PlayListSetting setMusicList,
    required ShufflePlayListSetting shuffleMusicList,
    required MusicController playController,
    required MusicController previousPlayController,
    required MusicController stopController,
    required MusicController nextPlayController,
    required RepeatChange repeatChange,
    required ShuffleChange shuffleChange,
  })  : _songRepository = songRepository,
        _setMusicList = setMusicList,
        _shuffleMusicList = shuffleMusicList,
        _playController = playController,
        _previousPlayController = previousPlayController,
        _stopController = stopController,
        _nextPlayController = nextPlayController,
        _repeatChange = repeatChange,
        _shuffleChange = shuffleChange,
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
    _audioPlayer = _audioRepository.audioPlayer;

    _audioPlayerStateStream();
    _audioPlayerPositionStream();

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
    _playList = await _setMusicList.execute(index: index, songList: _songList);
    notifyListeners();
    clickPlayButton();
  }

  // TODO: 메인 화면 서플 버튼 누를시
  void shufflePlayList() async {
    _playList = await _shuffleMusicList.execute(songList: _songList);
    notifyListeners();
    clickPlayButton();
  }

  // TODO: 음악 멈추기
  void stopMusic() {
    _stopController.execute();
  }

  // TODO: 재생 버튼 누르기
  void clickPlayButton() {
    _playController.execute();
  }

  // TODO: 프로그레스 바 클릭 이벤트
  void seek(Duration position) {
    _audioPlayer.seek(position);
  }

  // TODO: 다음 곡
  void nextPlay() {
    _nextPlayController.execute();
  }

  // TODO: 이전 곡
  void previousPlay() async {
    _previousPlayController.execute();
  }

  // TODO: 반복 재생 버튼 클릭
  void repeatModeChange() {
    final result = _repeatChange.execute(_mainState.repeatState);
    _mainState = _mainState.copyWith(
        repeatState : result
    );
    notifyListeners();
  }

  // TODO: 서플 여부 버튼 클릭
  void shuffleModeChange() async {
    await _shuffleChange.execute(isShuffleModeEnabled: _mainState.isShuffleModeEnabled);
    notifyListeners();
  }
  //
  void _audioPlayerStateStream() {
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
  }


  // 프로그레스바 사용을 위한 메소드
  void _audioPlayerPositionStream() {
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
