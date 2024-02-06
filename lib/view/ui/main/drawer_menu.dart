import 'package:flutter/material.dart';
import 'package:music_player/core/screen_change_state.dart';
import 'package:music_player/view/ui/sleep_timer/sleep_timer.dart';
import 'package:music_player/view/view_model/main_view_model.dart';
import 'package:provider/provider.dart';

import '../../view_model/audio_view_model.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MainViewModel>();
    final audioViewModel = context.watch<AudioViewModel>();
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
        ListTile(
          leading: const Icon(Icons.more_time_rounded),
          title: const Text('sleep timer'),
          onTap: () {
            final myModel = Provider.of<AudioViewModel>(context, listen: false);
            showDialog(
              context: context,
              barrierDismissible: true, //바깥 영역 터치시 닫을지 여부 결정
              builder: ((context) {
                return ChangeNotifierProvider.value(
                    value: myModel,
                    child: SleepTimer(
                      oldHour: audioViewModel.state.hour,
                      oldMinutes: audioViewModel.state.minutes,
                      oldSleepTimerEnabled: audioViewModel.state.isSleepTimerEnabled,
                    ),
                );
              }),
            );
          },
        ),
      ],
    );
  }
}
