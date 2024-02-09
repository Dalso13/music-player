import 'package:flutter/material.dart';
import 'package:pristine_sound/view/ui_sealed/drawer_event.dart';
import 'package:provider/provider.dart';

import '../../../domain/model/audio_model.dart';
import '../../view_model/audio_view_model.dart';
import '../../view_model/main_view_model.dart';
import '../audio_part/audio_bar_check.dart';
import '../sleep_timer/sleep_timer.dart';
import '../song_part/detail_song_menu.dart';
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
      endDrawer: Drawer(
        child: DrawerMenu(
          state: mainViewModel.mainState,
          onTab: (DrawerEvent event) {
            switch (event) {
              case HomeChange():
                mainViewModel.homeChange();
                break;
              case PlayListChange():
                mainViewModel.playListChange();
                break;
              case SleepTimerOnTap():
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (context) {
                    return ChangeNotifierProvider.value(
                      value: audioViewModel,
                      child: SleepTimer(
                        oldHour: audioViewModel.state.hour,
                        oldMinutes: audioViewModel.state.minutes,
                        oldSleepTimerEnabled:
                            audioViewModel.state.isSleepTimerEnabled,
                      ),
                    );
                  },
                );
            }
          },
        ),
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
                            : MusicList(
                                audioModel: state.songList,
                                currentId: state.nowPlaySong.id,
                                playMusic: ({required AudioModel audioModel}) {
                                  audioViewModel.playMusic(
                                      index:
                                          state.songList.indexOf(audioModel));
                                },
                                onLongPress: (
                                    {required AudioModel audioModel}) {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(30))),
                                    builder: (context) {
                                      return DraggableScrollableSheet(
                                        expand: false,
                                        initialChildSize: 0.3,
                                        builder: (context, scrollController) =>
                                            ChangeNotifierProvider.value(
                                          value: audioViewModel,
                                          child:
                                              DetailSongMenu(song: audioModel),
                                        ),
                                      );
                                    },
                                  );
                                },
                                detailSongMenu: (
                                    {required AudioModel audioModel}) {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(30))),
                                    builder: (context) {
                                      return DraggableScrollableSheet(
                                        expand: false,
                                        initialChildSize: 0.3,
                                        builder: (context, scrollController) =>
                                            ChangeNotifierProvider.value(
                                          value: audioViewModel,
                                          child:
                                              DetailSongMenu(song: audioModel),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                        const MainPlayListScreen(),
                        //const Center(child: Text('준비중'),)
                      ],
                    ),
            ),
          ),
          const AudioBarCheck(),
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
