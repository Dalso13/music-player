import 'package:flutter/material.dart';
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
          const AudioBar(),
          Expanded(
            child: ListView(
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
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  subtitle: Text('$idx : ${state.currentIndex}'),
                  trailing: Text(DateFormat('mm:ss').format(DateTime.fromMillisecondsSinceEpoch(e.duration)),
                      style: TextStyle(color: Colors.grey)),
                  leading: AudioImage(audioId: e.id),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
