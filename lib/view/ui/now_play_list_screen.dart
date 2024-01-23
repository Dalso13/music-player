import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:music_player/view/ui/audio_bar.dart';
import 'package:music_player/view/view_model/main_view_model.dart';
import 'package:provider/provider.dart';

import 'audio_image.dart';

class NowPlayListScreen extends StatelessWidget {
  const NowPlayListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MainViewModel>();
    final state = viewModel.mainState;
    return Scaffold(
      body: Column(
        children: [
          const AudioBar(),
          Expanded(
            child: ListView(
              children: viewModel.playList.map((e) {
                int idx = viewModel.playList.indexOf(e);
                return ListTile(
                  tileColor: idx == state.currentIndex ? Colors.grey[200] : null,
                  onTap: () {
                    if (idx == state.currentIndex) {
                      return;
                    }
                    viewModel.clickPlayListSong(idx: idx);
                  },
                  title: Text(e.displayNameWOExt,
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  subtitle: Text(e.artist),
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
