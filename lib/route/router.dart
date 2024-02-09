import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../di/di_setup.dart';
import '../view/ui/custom_play_list/add_music_screen.dart';
import '../view/ui/custom_play_list/play_list_detail_screen.dart';
import '../view/ui/custom_play_list/remove_music_screen.dart';
import '../view/ui/main/main_screen.dart';
import '../view/view_model/audio_view_model.dart';
import '../view/view_model/main_view_model.dart';
import '../view/view_model/play_list_view_model.dart';

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
        int index = state.extra as int;
        return MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: _audioViewModel),
            ChangeNotifierProvider(create: (_) => getIt<PlayListViewModel>()),
          ],
          child: PlayListDetailScreen(
            index: index,
          ),
        );
      },
    ),
    GoRoute(
      path: '/custom-play-list/add-music',
      builder: (context, state) {
        int index = state.extra as int;
        return MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: _audioViewModel),
            ChangeNotifierProvider(create: (_) => getIt<PlayListViewModel>()),
          ],
          child: AddMusicScreen(
            index: index,
          ),
        );
      },
    ),
    GoRoute(
      path: '/custom-play-list/remove-music',
      builder: (context, state) {
        int index = state.extra as int;
        return MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: _audioViewModel),
            ChangeNotifierProvider(create: (_) => getIt<PlayListViewModel>()),
          ],
          child: RemoveMusicScreen(
            index: index,
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
