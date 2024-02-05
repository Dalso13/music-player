import 'package:flutter/material.dart';
import 'package:music_player/core/screen_change_state.dart';
import 'package:music_player/view/view_model/main_view_model.dart';
import 'package:provider/provider.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MainViewModel>();
    return ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: [
        const DrawerHeader(
            child: Text(
          'Music Player',
        )),
        ListTile(
          leading: const Icon(Icons.home),
          title: const Text('home'),
          selected: viewModel.mainState.screenChangeState == ScreenChangeState.home,
          onTap: () {
            viewModel.homeChange();
          },
        ),
        ListTile(
          leading: const Icon(Icons.playlist_add_check),
          title: const Text('play list'),
          selected: viewModel.mainState.screenChangeState == ScreenChangeState.playList,
          onTap: () {
            viewModel.playListChange();
          },
        ),
        const Divider(
          height: 1,
          thickness: 1,
        ),
        const ListTile(
          leading: Icon(Icons.more_time_rounded),
          title: Text('sleep timer'),
        ),
      ],
    );
  }
}
