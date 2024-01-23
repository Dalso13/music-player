import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:music_player/view/view_model/main_view_model.dart';
import 'package:provider/provider.dart';

import 'audio_image.dart';

class MusicListView extends StatelessWidget {
  const MusicListView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MainViewModel>();
    final state = viewModel.mainState;
    return ListView(
      children: viewModel.songList.map((e) {
        int idx = viewModel.playList.isEmpty ? -1 : viewModel.playList.indexOf(e);
        return ListTile(
          tileColor: idx == state.currentIndex ? Colors.grey[200] : null,
          onTap: () {
            if (idx == state.currentIndex) {
              return;
            }
            viewModel.playMusic(index: viewModel.songList.indexOf(e));
          },
          title: Text(e.displayNameWOExt,
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          subtitle: Text(e.artist),
          trailing: Text(DateFormat('mm:ss').format(DateTime.fromMillisecondsSinceEpoch(e.duration)),
              style: TextStyle(color: Colors.grey)),
          leading: AudioImage(audioId: e.id),
        );
      }).toList(),
    );
  }
}
