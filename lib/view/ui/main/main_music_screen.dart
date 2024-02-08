import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view_model/audio_view_model.dart';
import '../../view_model/main_view_model.dart';
import '../audio_part/audio_bar_check.dart';
import '../song_part/music_list.dart';
import 'drawer_menu.dart';
import 'main_bottom_navigation_bar.dart';
import 'main_play_list_screen.dart';

class MainMusicScreen extends StatelessWidget {
  const MainMusicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AudioViewModel audioViewModel = context.watch<AudioViewModel>();
    final MainViewModel mainViewModel = context.watch<MainViewModel>();
    final state = audioViewModel.state;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pristine Sound'),
        backgroundColor: Theme.of(context).primaryColorLight,
      ),
      endDrawer: const Drawer(
        child: DrawerMenu(),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: audioViewModel.state.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : PageView(
                      controller: mainViewModel.pageController,
                      onPageChanged: (index) {
                        mainViewModel.scrollPageChange(index: index);
                      },
                      children: [
                        state.songList.isEmpty
                            ? const Center(child: Text("Nothing found!"))
                            : MusicList(audioModel: state.songList),
                        const MainPlayListScreen(),
                        //const Center(child: Text('준비중'),)
                      ],
                    ),
            ),
          ),
          AudioBarCheck(isBool: audioViewModel.state.playList.isNotEmpty),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        onPressed: audioViewModel.shufflePlayList,
        child: const Icon(Icons.shuffle),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndDocked,
      bottomNavigationBar: const MainBottomNavigationBar(),
    );
  }
}
