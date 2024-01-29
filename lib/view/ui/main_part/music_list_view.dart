import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:music_player/view/view_model/main_view_model.dart';
import 'package:provider/provider.dart';

import '../audio_part/audio_image.dart';

class MusicListView extends StatelessWidget {
  const MusicListView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MainViewModel>();
    final state = viewModel.mainState;
    final song = state.nowPlaySong;
    return ListView(
      children: state.songList.map((e) {
        bool isEquals = e.id == song.id;
        return ListTile(
          tileColor:isEquals
                  ? Colors.grey[200]
                  : null,
          onTap: () {
            if (isEquals) {
              return;
            }
            viewModel.playMusic(index: state.songList.indexOf(e));
          },
          title: Text(e.displayNameWOExt,
              maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold),),
          subtitle:
              Text(e.artist, maxLines: 1, overflow: TextOverflow.ellipsis),
          trailing: Text(
              DateFormat('mm:ss')
                  .format(DateTime.fromMillisecondsSinceEpoch(e.duration)),
              style: TextStyle(color: Colors.grey)),
          leading: AudioImage(audioId: e.id),
        );
      }).toList(),
    );
  }
}
