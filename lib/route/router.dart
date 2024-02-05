import 'package:go_router/go_router.dart';
import 'package:music_player/view/ui/custom_play_list/remove_music_screen.dart';
import 'package:music_player/view/ui/main/main_screen.dart';
import 'package:music_player/view/ui/custom_play_list/play_list_detail_screen.dart';
import 'package:music_player/view/view_model/audio_view_model.dart';
import 'package:music_player/view/view_model/main_view_model.dart';
import 'package:provider/provider.dart';
import '../di/di_setup.dart';
import '../view/ui/custom_play_list/add_music_screen.dart';
import '../view/view_model/play_list_model.dart';

final _audioViewModel = getIt<AudioViewModel>();

final router = GoRouter(
  initialLocation: '/main',
  routes: [
    GoRoute(
      path: '/main',
      builder: (context, state) => MultiProvider(providers: [
        ChangeNotifierProvider.value(value: _audioViewModel),
        ChangeNotifierProvider(create: (_) => getIt<MainViewModel>()),
        ChangeNotifierProvider(create: (_) => getIt<PlayListViewModel>()),
      ], child: const MainScreen()),
    ),
    GoRoute(
      path: '/custom-play-list',
      builder: (context, state) {
        int modelKey = state.extra as int;
        return MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: _audioViewModel),
            ChangeNotifierProvider(create: (_) => getIt<PlayListViewModel>()),
          ],
          child: PlayListDetailScreen(
            modelKey: modelKey,
          ),
        );
      },
    ),
    GoRoute(
      path: '/custom-play-list/add-music',
      builder: (context, state) {
        int modelKey = state.extra as int;
        return MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: _audioViewModel),
            ChangeNotifierProvider(create: (_) => getIt<PlayListViewModel>()),
          ],
          child: AddMusicScreen(
            modelKey: modelKey,
          ),
        );
      },
    ),
    GoRoute(
      path: '/custom-play-list/remove-music',
      builder: (context, state) {
        int modelKey = state.extra as int;
        return MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: _audioViewModel),
            ChangeNotifierProvider(create: (_) => getIt<PlayListViewModel>()),
          ],
          child: RemoveMusicScreen(
            modelKey: modelKey,
          ),
        );
      },
    ),
  ],
);

// final router = GoRouter(
//   initialLocation: '/',
//   routes: [
//     GoRoute(
//         path: '/',
//         builder: (context, state) => ChangeNotifierProvider(
//             create: (_) => getIt<MainViewModel>(), child: const MainScreen())),
//     GoRoute(
//         path: '/permission',
//         builder: (context, state) => const PermissionPage()),
//     GoRoute(
//         path: '/now-music',
//         builder: (context, state) => ChangeNotifierProvider(
//             create: (_) => getIt<MainViewModel>(), child: const NowPlayMusicScreen())),
//     GoRoute(
//         path: '/now-play-list',
//         builder: (context, state) => ChangeNotifierProvider(
//             create: (_) => getIt<MainViewModel>(), child: const NowPlayListScreen())),
//   ],
// );
