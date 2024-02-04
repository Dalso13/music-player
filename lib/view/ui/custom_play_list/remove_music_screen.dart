import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../view_model/audio_view_model.dart';
import '../../view_model/hive_view_model.dart';
import '../audio_part/audio_image.dart';

class RemoveMusicScreen extends StatelessWidget {
  final int _modelKey;

  const RemoveMusicScreen({
    super.key,
    required int modelKey,
  }) : _modelKey = modelKey;

  @override
  Widget build(BuildContext context) {
    final hiveViewModel = context.watch<HiveViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text('remove music'),
        actions: [
          IconButton(
              onPressed: () {
                hiveViewModel.removePlayListSong(modelKey: _modelKey);
                context.pop();
              },
              icon: Icon(Icons.check))
        ],
      ),
      body: ListView(
        children: hiveViewModel
            .customPlayList[hiveViewModel.getIndex(_modelKey)].playList
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
