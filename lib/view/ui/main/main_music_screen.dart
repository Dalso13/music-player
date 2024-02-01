import 'package:flutter/material.dart';
import 'package:music_player/view/ui/main/main_play_list_screen.dart';
import 'package:provider/provider.dart';

import '../../view_model/audio_view_model.dart';
import '../../view_model/main_view_model.dart';
import '../audio_part/audio_bar.dart';
import '../audio_part/empty_audio_bar.dart';
import '../play_screen/now_play_track_screen.dart';
import '../song_part/music_list_view.dart';
import 'drawer_menu.dart';
import 'main_bottom_navigation_bar.dart';

class MainMusicScreen extends StatelessWidget {
  const MainMusicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AudioViewModel audioViewModel = context.watch<AudioViewModel>();
    final MainViewModel mainViewModel = context.watch<MainViewModel>();
    final state = audioViewModel.mainState;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Music Player'),
      ),
      endDrawer: const Drawer(
        child: DrawerMenu(),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: audioViewModel.mainState.isLoading
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
                            ? const Text("Nothing found!")
                            : const MusicListView(),
                        const MainPlayListScreen(),
                      ],
                    ),
            ),
          ),
          audioViewModel.mainState.playList.isNotEmpty
              ? GestureDetector(
                  onTap: () {
                    final myModel =
                        Provider.of<AudioViewModel>(context, listen: false);
                    showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (context) {
                          return ChangeNotifierProvider.value(
                              value: myModel,
                              child: const NowPlayTrackScreen());
                        });
                  },
                  child:
                      Container(color: Colors.white, child: const AudioBar()),
                )
              : const EmptyAudioBar(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        onPressed: audioViewModel.shufflePlayList,
        child: Icon(Icons.shuffle),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndDocked,
      bottomNavigationBar: const MainBottomNavigationBar(),
    );
  }
}
