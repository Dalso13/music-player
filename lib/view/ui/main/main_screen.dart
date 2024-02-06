import 'package:flutter/material.dart';
import 'package:music_player/view/ui/main/main_music_screen.dart';
import 'package:music_player/view/ui/main/permission_page.dart';
import 'package:music_player/view/view_model/audio_view_model.dart';
import 'package:music_player/view/view_model/main_view_model.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<MainViewModel>().init().then((_) {
        if (context.read<MainViewModel>().mainState.isPermission) {
          context.read<AudioViewModel>().init();
          context.read<MainViewModel>().dataCheck();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final MainViewModel mainViewModel = context.watch<MainViewModel>();
    return mainViewModel.mainState.isPermissionLoading
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : mainViewModel.mainState.isPermission
            ? const MainMusicScreen()
            : const PermissionPage();
  }
}
