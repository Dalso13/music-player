import 'package:get_it/get_it.dart';
import 'package:music_player/data/reposiotry/song_repository.dart';
import 'package:music_player/data/reposiotry/song_repository_impl.dart';
import 'package:music_player/domain/use_case/button_change/interface/shuffle_change.dart';
import 'package:music_player/domain/use_case/music_controller/interface/next_play_controller.dart';
import 'package:music_player/domain/use_case/music_controller/interface/play_controller.dart';
import 'package:music_player/domain/use_case/music_controller/interface/previous_play_controller.dart';
import 'package:music_player/domain/use_case/music_controller/interface/stop_controller.dart';
import 'package:music_player/domain/use_case/play_list/impl/set_music_list.dart';
import 'package:music_player/domain/use_case/play_list/interface/play_list_setting.dart';
import 'package:music_player/domain/use_case/play_list/interface/shuffle_play_list_setting.dart';
import 'package:music_player/view/view_model/main_view_model.dart';
import '../domain/use_case/button_change/impl/repeat_change_impl.dart';
import '../domain/use_case/button_change/impl/shuffle_change_impl.dart';
import '../domain/use_case/button_change/interface/repeat_change.dart';
import '../domain/use_case/play_list/impl/shuffle_music_list.dart';

final getIt = GetIt.instance;

void diSetup() {
  getIt.registerSingleton<SongRepository>(SongRepositoryImpl());

  // USE_CASE
  getIt.registerSingleton<NextPlayController>(NextPlayController());
  getIt.registerSingleton<PlayController>(PlayController());
  getIt.registerSingleton<PreviousPlayController>(PreviousPlayController());
  getIt.registerSingleton<StopController>(StopController());

  getIt.registerSingleton<PlayListSetting>(SetMusicList());
  getIt.registerSingleton<ShufflePlayListSetting>(ShuffleMusicList());

  getIt.registerSingleton<RepeatChange>(RepeatChangeImpl());
  getIt.registerSingleton<ShuffleChange>(ShuffleChangeImpl());
  // USE_CASE

  getIt.registerFactory<MainViewModel>(() => MainViewModel(
      songRepository: getIt<SongRepository>(),
      setMusicList: getIt<PlayListSetting>(),
      shuffleMusicList: getIt<ShufflePlayListSetting>(),
      playController: getIt<PlayController>(),
      previousPlayController: getIt<PreviousPlayController>(),
      stopController: getIt<StopController>(),
      nextPlayController: getIt<NextPlayController>(),
      repeatChange: getIt<RepeatChange>(),
      shuffleChange: getIt<ShuffleChange>()));
}
