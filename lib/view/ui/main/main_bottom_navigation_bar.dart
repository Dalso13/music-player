import 'package:flutter/material.dart';
import 'package:music_player/core/screen_change_state.dart';
import 'package:music_player/view/view_model/main_view_model.dart';
import 'package:provider/provider.dart';

class MainBottomNavigationBar extends StatelessWidget {
  const MainBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final MainViewModel viewModel = context.watch<MainViewModel>();
    return BottomNavigationBar(
      type: BottomNavigationBarType.shifting,
      selectedItemColor: Colors.lightBlue[500],
      unselectedItemColor: Colors.grey,
      currentIndex: viewModel.mainState.screenChangeState.idx,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.playlist_add_check), label: 'play list'),
      ],
      onTap: (int i) => {
        if (i == ScreenChangeState.playList.idx) {
          viewModel.playListChange()
        } else if (i == ScreenChangeState.home.idx) {
          viewModel.homeChange()
        }

      },
    );
  }
}
