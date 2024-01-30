import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:music_player/view/ui/audio_part/audio_bar.dart';
import 'package:music_player/view/ui/song_part/song_tile.dart';
import 'package:music_player/view/view_model/main_view_model.dart';
import 'package:provider/provider.dart';

import '../audio_part/audio_image.dart';
import '../song_part/detail_song_control.dart';

class NowPlayListScreen extends StatelessWidget {
  const NowPlayListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MainViewModel>();
    final state = viewModel.mainState;
    final song = state.nowPlaySong;

    return Scaffold(
      backgroundColor: Color(state.artColor).withOpacity(0.6),
      body: Column(
        children: [
          const SafeArea(child: AudioBar()),
          Expanded(
            child: Column(
              children: [
                Container(
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16.0),
                      topRight: Radius.circular(16.0),
                    ),
                    color: Color(state.artColor),
                  ),
                  child: InkWell(
                    onTap: () => context.pop(),
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Container(
                            child: const Column(
                              children: [
                                Icon(Icons.playlist_add, color: Colors.black),
                                Text('List',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.only(top: 0),
                    children: state.playList.asMap().entries.map((map) {
                      int idx = map.key;
                      final e = map.value;
                      final bool isEqual = viewModel.mainState.currentIndex == idx;
                      return GestureDetector(
                          onLongPress: () {
                            final myModel = Provider.of<MainViewModel>(context, listen: false);
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.vertical(top: Radius.circular(30))),
                              builder: (context) {
                                return DraggableScrollableSheet(
                                  expand: false,
                                  initialChildSize: 0.3,
                                  builder: (context, scrollController) =>
                                      ChangeNotifierProvider.value(
                                        value: myModel,
                                        child: DetailSongControl(song: e),
                                      ),
                                );
                              },
                            );
                          },
                          onTap: () {
                            if (isEqual) {
                              return;
                            }
                            viewModel.clickPlayListSong(idx: idx);
                          },
                          child: SongTile(song: e, isEqual: isEqual));
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
