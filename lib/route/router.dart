import 'package:go_router/go_router.dart';
import 'package:music_player/view/ui/main/main_screen.dart';
import 'package:music_player/view/ui/main/permission_page.dart';
import 'package:music_player/view/view_model/audio_view_model.dart';
import 'package:music_player/view/view_model/main_view_model.dart';
import 'package:provider/provider.dart';
import '../di/di_setup.dart';

final _value = getIt<AudioViewModel>();


final router = GoRouter(
  initialLocation: '/main',
  routes: [
    GoRoute(
      path: '/main',
      builder: (context, state) => MultiProvider(providers: [
        ChangeNotifierProvider.value(value: _value),
        ChangeNotifierProvider(create: (_) => getIt<MainViewModel>()),
      ], child: const MainScreen()),
    ),
    // GoRoute(
    //   path: '/now-music',
    //   builder: (context, state) => ChangeNotifierProvider.value(value: _value,  child: const NowPlayMusicScreen())
    // ),
    // GoRoute(
    //   path: '/now-play-list',
    //   builder: (context, state) => ChangeNotifierProvider.value(value: _value,  child: const NowPlayListScreen())
    // ),
  ],
);
final permissionRouter = GoRouter(
  initialLocation: '/permission',
  routes: [
    GoRoute(
      path: '/main',
      builder: (context, state) => MultiProvider(providers: [
        ChangeNotifierProvider.value(value: _value),
        ChangeNotifierProvider(create: (_) => getIt<MainViewModel>()),
      ], child: const MainScreen()),
    ),
    GoRoute(
        path: '/permission',
        builder: (context, state) => const PermissionPage()),
    // GoRoute(
    //   path: '/now-music',
    //   builder: (context, state) => ChangeNotifierProvider.value(value: _value,  child: const NowPlayMusicScreen())
    // ),
    // GoRoute(
    //   path: '/now-play-list',
    //   builder: (context, state) => ChangeNotifierProvider.value(value: _value,  child: const NowPlayListScreen())
    // ),
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
