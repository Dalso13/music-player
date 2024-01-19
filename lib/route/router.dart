import 'package:go_router/go_router.dart';
import 'package:music_player/view/ui/main_screen.dart';
import 'package:music_player/view/view_model/main_view_model.dart';
import 'package:provider/provider.dart';
import '../di/di_setup.dart';



final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => ChangeNotifierProvider(
          create: (_) {
            return getIt<MainViewModel>();
          },
          child: const MainScreen()),
    ),
  ],
);
