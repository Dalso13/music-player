import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pristine_sound/route/router.dart';
import 'di/di_setup.dart';
import 'domain/model/audio_model.dart';
import 'domain/model/custom_play_list_model.dart';



void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(AudioModelAdapter());
  Hive.registerAdapter(CustomPlayListModelAdapter());
  await Hive.openBox<CustomPlayListModel>('customPlayList');
  await diSetup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        routerConfig: router,
        title: 'Pristine Sound',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
          useMaterial3: true,
        ),
    );
  }
}
