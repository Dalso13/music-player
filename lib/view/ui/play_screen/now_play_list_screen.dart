import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:music_player/view/ui/audio_part/audio_bar.dart';
import 'package:music_player/view/view_model/main_view_model.dart';
import 'package:provider/provider.dart';

import '../audio_part/audio_image.dart';

class NowPlayListScreen extends StatelessWidget {
  const NowPlayListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MainViewModel>();
    final state = viewModel.mainState;
    final song = state.nowPlaySong;

    return Scaffold(
      body: Column(
        children: [
          const SafeArea(child: AudioBar()),
          Expanded(
            child: Column(
              children: [
                Container(
                  width: double.maxFinite,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
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
                                Icon(Icons.playlist_add,
                                    color: Colors.deepPurple),
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
                    children: state.playList.map((e) {
                      int idx = state.playList.indexOf(e);
                      return ListTile(
                        tileColor: e.id == song.id ? Colors.grey[200] : null,
                        onTap: () {
                          if (e.id == song.id) {
                            return;
                          }
                          viewModel.clickPlayListSong(idx: idx);
                        },
                        title: Text(e.displayNameWOExt,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(e.artist),
                        trailing: Text(
                            DateFormat('mm:ss').format(
                                DateTime.fromMillisecondsSinceEpoch(
                                    e.duration)),
                            style: TextStyle(color: Colors.grey)),
                        leading: AudioImage(audioId: e.id),
                      );
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
