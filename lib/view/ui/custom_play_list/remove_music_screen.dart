import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../view_model/play_list_model.dart';
import '../audio_part/audio_image.dart';

class RemoveMusicScreen extends StatelessWidget {
  final int _modelKey;

  const RemoveMusicScreen({
    super.key,
    required int modelKey,
  }) : _modelKey = modelKey;

  @override
  Widget build(BuildContext context) {
    final playListViewModel = context.watch<PlayListViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('remove music'),
        backgroundColor: Theme.of(context).primaryColorLight,
        actions: [
          IconButton(
              onPressed: () {
                playListViewModel.removePlayListSong(modelKey: _modelKey);
                context.pop();
              },
              icon: const Icon(Icons.check))
        ],
      ),
      body: ListView(
        children: playListViewModel
            .state.customPlayList[playListViewModel.getIndex(_modelKey)].playList
            .toList()
            .map((e) {
          return ListTile(
            title: Text(e.displayNameWOExt,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                maxLines: 1,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  e.artist,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  maxLines: 1,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
            leading: AudioImage(audioId: e.id),
            trailing: IconButton(
                onPressed: () {
                  playListViewModel.selectMusic(audioModel: e);
                },
                icon: playListViewModel.state.selectList.contains(e)
                    ? const Icon(Icons.check_box)
                    : const Icon(Icons.check_box_outline_blank)),
          );
        }).toList(),
      ),
    );
  }
}
