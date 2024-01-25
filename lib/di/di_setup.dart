import 'package:audio_service/audio_service.dart';
import 'package:get_it/get_it.dart';
import 'package:music_player/domain/repository/song_repository.dart';
import 'package:music_player/data/repository/song_repository_impl.dart';
import 'package:music_player/domain/use_case/audio_player_stream/impl/audio_player_state_stream_impl.dart';
import 'package:music_player/domain/use_case/audio_player_stream/interface/audio_player_state_stream.dart';
import 'package:music_player/domain/use_case/button_change/interface/shuffle_change.dart';
import 'package:music_player/domain/use_case/music_controller/impl/next_play_controller.dart';
import 'package:music_player/domain/use_case/music_controller/impl/play_controller.dart';
import 'package:music_player/domain/use_case/music_controller/impl/previous_play_controller.dart';
import 'package:music_player/domain/use_case/music_controller/impl/seek_controller_impl.dart';
import 'package:music_player/domain/use_case/music_controller/impl/stop_controller.dart';
import 'package:music_player/domain/use_case/music_controller/interface/seek_controller.dart';
import 'package:music_player/domain/use_case/play_list/impl/click_play_list_song_impl.dart';
import 'package:music_player/domain/use_case/play_list/impl/set_music_list.dart';
import 'package:music_player/domain/use_case/play_list/interface/click_play_list_song.dart';
import 'package:music_player/domain/use_case/play_list/interface/play_list_setting.dart';
import 'package:music_player/domain/use_case/play_list/interface/shuffle_play_list_setting.dart';
import 'package:music_player/view/view_model/main_view_model.dart';
import '../domain/service/audio_handler.dart';
import '../domain/use_case/button_change/impl/repeat_change_impl.dart';
import '../domain/use_case/button_change/impl/shuffle_change_impl.dart';
import '../domain/use_case/button_change/interface/repeat_change.dart';
import '../domain/use_case/play_list/impl/shuffle_music_list.dart';

final getIt = GetIt.instance;

Future<void> diSetup() async {
  getIt.registerSingleton<SongRepository>(SongRepositoryImpl());

  // USE_CASE
  getIt.registerSingleton<NextPlayController>(NextPlayController());
  getIt.registerSingleton<PlayController>(PlayController());
  getIt.registerSingleton<PreviousPlayController>(PreviousPlayController());
  getIt.registerSingleton<StopController>(StopController());

  getIt.registerSingleton<PlayListSetting>(SetMusicList());
  getIt.registerSingleton<ShufflePlayListSetting>(ShuffleMusicList());
  getIt.registerSingleton<ClickPlayListSong>(ClickPlayListSongImpl());

  getIt.registerSingleton<RepeatChange>(RepeatChangeImpl());
  getIt.registerSingleton<ShuffleChange>(ShuffleChangeImpl());
  getIt.registerSingleton<SeekController>(SeekControllerImpl());

  getIt.registerSingleton<AudioPlayerStateStream>(AudioPlayerStateStreamImpl());
  // USE_CASE

  //background-service
  getIt.registerSingleton<AudioHandler>(await initAudioService());

  getIt.registerFactory<MainViewModel>(() => MainViewModel(
         songRepository: getIt<SongRepository>(),
          audioHandler:  getIt<AudioHandler>(),
        // setMusicList: getIt<PlayListSetting>(),
        // shuffleMusicList: getIt<ShufflePlayListSetting>(),
        // playController: getIt<PlayController>(),
        // previousPlayController: getIt<PreviousPlayController>(),
        // stopController: getIt<StopController>(),
        // nextPlayController: getIt<NextPlayController>(),
        // repeatChange: getIt<RepeatChange>(),
        // shuffleChange: getIt<ShuffleChange>(),
        // clickPlayListSong: getIt<ClickPlayListSong>(),
        // seekController: getIt<SeekController>(),
        // audioPlayerPositionStream: getIt<AudioPlayerStateStream>(),
      ));

}

Future<AudioHandler> initAudioService() async {
  return await AudioService.init(
    builder: () => MyAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.mycompany.myapp.audio',
      androidNotificationChannelName: 'Audio Service Demo',
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: true,
    ),
  );
}

// getIt.registerSingleton<MainViewModel>(MainViewModel(
//   songRepository: getIt<SongRepository>(),
//   setMusicList: getIt<PlayListSetting>(),
//   shuffleMusicList: getIt<ShufflePlayListSetting>(),
//   playController: getIt<PlayController>(),
//   previousPlayController: getIt<PreviousPlayController>(),
//   stopController: getIt<StopController>(),
//   nextPlayController: getIt<NextPlayController>(),
//   repeatChange: getIt<RepeatChange>(),
//   shuffleChange: getIt<ShuffleChange>(),
//   clickPlayListSong: getIt<ClickPlayListSong>(),
//   seekController: getIt<SeekController>(),
//   audioPlayerPositionStream: getIt<AudioPlayerStateStream>(),
// ));
