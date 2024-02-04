import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../view_model/audio_view_model.dart';
import '../../view_model/hive_view_model.dart';
import '../audio_part/audio_image.dart';

class AddMusicScreen extends StatelessWidget {
  final int _modelKey;

  const AddMusicScreen({
    super.key,
    required int modelKey,
  }) : _modelKey = modelKey;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AudioViewModel>();
    final hiveViewModel = context.watch<HiveViewModel>();
    final state = viewModel.mainState;
    final list = state.songList
        .where((e) =>
            hiveViewModel
                .customPlayList[hiveViewModel.getIndex(_modelKey)].playList
                .toList()
                .contains(e) ==
            false)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('add music'),
        actions: [
          IconButton(
              onPressed: () {
                hiveViewModel.addSongPlayList(modelKey: _modelKey);
                context.pop();
              },
              icon: Icon(Icons.check))
        ],
      ),
      body: ListView(
        children: list.map((e) {
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
                  hiveViewModel.selectMusic(audioModel: e);
                },
                icon: hiveViewModel.selectList.contains(e)
                    ? Icon(Icons.check_box)
                    : const Icon(Icons.check_box_outline_blank)),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSelectIcon() {
    return Icon(
      Icons.check_box,
    );
  }
}
