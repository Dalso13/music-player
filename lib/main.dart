import 'package:flutter/material.dart';
import 'package:music_player/di/di_setup.dart';
import 'package:music_player/route/router.dart';
import 'package:music_player/view/view_model/main_view_model.dart';
import 'package:provider/provider.dart';

void main() {
  diSetup();
  runApp(ChangeNotifierProvider(
      create: (_) {
        return getIt<MainViewModel>();
      },
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        routerConfig: router,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ));
  }
}
