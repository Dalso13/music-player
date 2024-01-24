import 'package:go_router/go_router.dart';
import 'package:music_player/view/ui/main/main_screen.dart';
import 'package:music_player/view/ui/play_screen/now_play_music_screen.dart';
import 'package:music_player/view/ui/main/permission_page.dart';
import 'package:music_player/view/view_model/main_view_model.dart';
import 'package:provider/provider.dart';
import '../di/di_setup.dart';
import '../view/ui/play_screen/now_play_list_screen.dart';

final _value = getIt<MainViewModel>();

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => ChangeNotifierProvider.value(value: _value, child: const MainScreen())
    ),
    GoRoute(
        path: '/permission',
        builder: (context, state) => const PermissionPage()
    ),
    GoRoute(
      path: '/now-music',
      builder: (context, state) => ChangeNotifierProvider.value(value: _value,  child: const NowPlayMusicScreen())
    ),
    GoRoute(
      path: '/now-play-list',
      builder: (context, state) => ChangeNotifierProvider.value(value: _value,  child: const NowPlayListScreen())
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