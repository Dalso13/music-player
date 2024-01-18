import 'package:get_it/get_it.dart';
import 'package:music_player/data/reposiotry/song_repository.dart';
import 'package:music_player/data/reposiotry/song_repository_impl.dart';
import 'package:music_player/view/view_model/main_view_model.dart';

final getIt = GetIt.instance;

void diSetup() {
  getIt.registerSingleton<SongRepository>(SongRepositoryImpl());
  getIt.registerFactory<MainViewModel>(() => MainViewModel(songRepository: getIt<SongRepository>()));
}