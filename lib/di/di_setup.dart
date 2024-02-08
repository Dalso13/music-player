import 'package:audio_service/audio_service.dart';
import 'package:get_it/get_it.dart';
import 'package:pristine_sound/domain/use_case/get_device_data/get_device_data.dart';
import 'package:pristine_sound/domain/use_case/get_device_data/get_device_data_impl.dart';
import '../data/repository/device_repository_impl.dart';
import '../data/repository/play_list_repository_impl.dart';
import '../data/repository/song_repository_impl.dart';
import '../domain/repository/device_repository.dart';
import '../domain/repository/play_list_repository.dart';
import '../domain/repository/song_repository.dart';
import '../domain/use_case/audio_player_stream/impl/audio_player_state_stream_impl.dart';
import '../domain/use_case/audio_player_stream/impl/dispose_controller_impl.dart';
import '../domain/use_case/audio_player_stream/impl/get_current_index_impl.dart';
import '../domain/use_case/audio_player_stream/interface/audio_player_state_stream.dart';
import '../domain/use_case/audio_player_stream/interface/dispose_controller.dart';
import '../domain/use_case/audio_player_stream/interface/get_current_index.dart';
import '../domain/use_case/button_change/impl/repeat_change_impl.dart';
import '../domain/use_case/button_change/impl/shuffle_change_impl.dart';
import '../domain/use_case/button_change/interface/repeat_change.dart';
import '../domain/use_case/button_change/interface/shuffle_change.dart';
import '../domain/use_case/color/impl/imag_base_color_impl.dart';
import '../domain/use_case/color/interface/imag_base_color.dart';
import '../domain/use_case/custom_play_list_box/impl/custom_play_list_data_check_impl.dart';
import '../domain/use_case/custom_play_list_box/impl/custom_play_list_set_box_impl.dart';
import '../domain/use_case/custom_play_list_box/impl/custom_play_list_update_box_impl.dart';
import '../domain/use_case/custom_play_list_box/impl/get_custom_play_list_impl.dart';
import '../domain/use_case/custom_play_list_box/impl/remove_custom_play_list_impl.dart';
import '../domain/use_case/custom_play_list_box/interface/custom_play_list_data_check.dart';
import '../domain/use_case/custom_play_list_box/interface/remove_custom_play_list.dart';
import '../domain/use_case/custom_play_list_box/interface/custom_play_list_set_box.dart';
import '../domain/use_case/custom_play_list_box/interface/custom_play_list_update_box.dart';
import '../domain/use_case/custom_play_list_box/interface/get_custom_play_list.dart';
import '../domain/use_case/music_controller/impl/next_play_controller.dart';
import '../domain/use_case/music_controller/impl/play_controller.dart';
import '../domain/use_case/music_controller/impl/previous_play_controller.dart';
import '../domain/use_case/music_controller/impl/seek_controller_impl.dart';
import '../domain/use_case/music_controller/impl/stop_controller.dart';
import '../domain/use_case/music_controller/interface/seek_controller.dart';
import '../domain/use_case/play_list/impl/add_song_impl.dart';
import '../domain/use_case/play_list/impl/click_play_list_song_impl.dart';
import '../domain/use_case/play_list/impl/insert_song_impl.dart';
import '../domain/use_case/play_list/impl/set_music_list.dart';
import '../domain/use_case/play_list/interface/add_song.dart';
import '../domain/use_case/play_list/interface/click_play_list_song.dart';
import '../domain/use_case/play_list/interface/insert_song.dart';
import '../domain/use_case/play_list/interface/play_list_setting.dart';
import '../domain/use_case/sleep_timer/impl/sleep_timer_pause_impl.dart';
import '../domain/use_case/sleep_timer/impl/sleep_timer_start_impl.dart';
import '../domain/use_case/sleep_timer/interface/sleep_timer_pause.dart';
import '../domain/use_case/sleep_timer/interface/sleep_timer_start.dart';
import '../service/audio_handler.dart';
import '../view/view_model/audio_view_model.dart';
import '../view/view_model/main_view_model.dart';
import '../view/view_model/play_list_view_model.dart';

final getIt = GetIt.instance;

Future<void> diSetup() async {
  getIt.registerSingleton<SongRepository>(SongRepositoryImpl());
  getIt.registerSingleton<PlayListRepository>(PlayListRepositoryImpl(
      songRepository: getIt<SongRepository>()
  ));
  getIt.registerSingleton<DeviceRepository>(DeviceRepositoryImpl());

  //background-service
  getIt.registerSingleton<AudioHandler>(await initAudioService());

  // USE_CASE
  getIt.registerSingleton<NextPlayController>(
      NextPlayController(audioService: getIt<AudioHandler>()));
  getIt.registerSingleton<PlayController>(
      PlayController(audioService: getIt<AudioHandler>()));
  getIt.registerSingleton<PreviousPlayController>(
      PreviousPlayController(audioService: getIt<AudioHandler>()));
  getIt.registerSingleton<StopController>(
      StopController(audioService: getIt<AudioHandler>()));

  getIt.registerSingleton<PlayListSetting>(
      SetMusicList(audioService: getIt<AudioHandler>()));
  getIt.registerSingleton<ClickPlayListSong>(ClickPlayListSongImpl());

  getIt.registerSingleton<RepeatChange>(
      RepeatChangeImpl(audioService: getIt<AudioHandler>()));
  getIt.registerSingleton<ShuffleChange>(
      ShuffleChangeImpl(audioService: getIt<AudioHandler>()));
  getIt.registerSingleton<SeekController>(
      SeekControllerImpl(audioService: getIt<AudioHandler>()));

  getIt.registerSingleton<AudioPlayerStateStream>(AudioPlayerStateStreamImpl());
  getIt.registerSingleton<DisposeController>(
      DisposeControllerImpl(audioService: getIt<AudioHandler>()));

  getIt.registerSingleton<ImageBaseColor>(ImageBaseColorImpl());

  getIt.registerSingleton<InsertSong>(
      InsertSongImpl(audioService: getIt<AudioHandler>()));
  getIt.registerSingleton<AddSong>(
      AddSongImpl(audioService: getIt<AudioHandler>()));
  getIt.registerSingleton<GetCurrentIndex>(GetCurrentIndexImpl());

  getIt.registerSingleton<SleepTimerStart>(
      SleepTimerStartImpl(audioService: getIt<AudioHandler>()));
  getIt.registerSingleton<SleepTimerPause>(
      SleepTimerPauseImpl(audioService: getIt<AudioHandler>()));

  getIt.registerSingleton<CustomPlayListUpdateBox>(CustomPlayListUpdateBoxImpl(
      playListRepository: getIt<PlayListRepository>()));
  getIt.registerSingleton<CustomPlayListSetBox>(CustomPlayListSetBoxImpl(
      playListRepository: getIt<PlayListRepository>()));
  getIt.registerSingleton<RemoveCustomPlayList>(RemoveCustomPlayListImpl(
      playListRepository: getIt<PlayListRepository>()));
  getIt.registerSingleton<GetCustomPlayList>(GetCustomPlayListImpl(
      playListRepository: getIt<PlayListRepository>()));
  getIt.registerSingleton<CustomPlayListDataCheck>(CustomPlayListDataCheckImpl(
      playListRepository: getIt<PlayListRepository>()));

  getIt.registerSingleton<GetDeviceData>(GetDeviceDataImpl(
      deviceRepository: getIt<DeviceRepository>()));
  // USE_CASE


  getIt.registerFactory<AudioViewModel>(() =>
      AudioViewModel(
        songRepository: getIt<SongRepository>(),
        audioHandler: getIt<AudioHandler>(),
        setMusicList: getIt<PlayListSetting>(),
        playController: getIt<PlayController>(),
        previousPlayController: getIt<PreviousPlayController>(),
        stopController: getIt<StopController>(),
        nextPlayController: getIt<NextPlayController>(),
        repeatChange: getIt<RepeatChange>(),
        shuffleChange: getIt<ShuffleChange>(),
        clickPlayListSong: getIt<ClickPlayListSong>(),
        seekController: getIt<SeekController>(),
        audioPlayerPositionStream: getIt<AudioPlayerStateStream>(),
        disposeController: getIt<DisposeController>(),
        imageBaseColor: getIt<ImageBaseColor>(),
        insertSong: getIt<InsertSong>(),
        addSong: getIt<AddSong>(),
        getCurrentIndex: getIt<GetCurrentIndex>(),
        sleepTimerStart: getIt<SleepTimerStart>(),
        sleepTimerPause: getIt<SleepTimerPause>(),
      ));


  getIt.registerFactory<MainViewModel>(() =>
      MainViewModel(
        customPlayListDataCheck: getIt<CustomPlayListDataCheck>(),
        getDeviceData: getIt<GetDeviceData>(),
      ));

  getIt.registerFactory <PlayListViewModel>(() =>
      PlayListViewModel(removeCustomPlayList: getIt<RemoveCustomPlayList>(),
        customPlayListSetBox: getIt<CustomPlayListSetBox>(),
        customPlayListUpdateBox: getIt<CustomPlayListUpdateBox>(),
        getCustomPlayList: getIt<GetCustomPlayList>(),
        customPlayListDataCheck: getIt<CustomPlayListDataCheck>(),
      ));
}

