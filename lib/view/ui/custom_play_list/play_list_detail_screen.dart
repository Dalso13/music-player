import 'package:flutter/material.dart';
import 'package:music_player/view/ui/audio_part/audio_image.dart';
import 'package:music_player/view/ui/custom_play_list/custom_play_list_menu/only_one_play_list_menu.dart';
import 'package:music_player/view/ui/song_part/music_list_view.dart';
import 'package:music_player/view/view_model/hive_view_model.dart';
import 'package:provider/provider.dart';

import '../../view_model/audio_view_model.dart';
import '../audio_part/audio_bar_check.dart';
import '../song_part/song_tile.dart';

class PlayListDetailScreen extends StatelessWidget {
  final int _modelKey;
  const PlayListDetailScreen({
    super.key, required int modelKey,
  }) : _modelKey = modelKey;

  @override
  Widget build(BuildContext context) {
    final AudioViewModel audioViewModel = context.watch<AudioViewModel>();
    final HiveViewModel hiveViewModel = context.watch<HiveViewModel>();
    final model = hiveViewModel.customPlayList[hiveViewModel.getIndex(_modelKey)];
    return Scaffold(
      appBar: AppBar(
        title: const Text('my play list'),
      ),
      body: Column(
        children: [
          SizedBox(
            width: double.maxFinite,
            height: 250,
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.all(20),
                  width: 200,
                  height: 200,
                  child: AudioImage(
                      audioId:
                          model.playList.isEmpty ? 0 : model.playList.first.id),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Text(model.title,
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis),
                            maxLines: 4),
                      ),
                      IconButton(
                          onPressed: () {
                            final viewModel = Provider.of<HiveViewModel>(context, listen: false);
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
                                      ChangeNotifierProvider.value(value: viewModel,
                                          child: OnlyOnePlayListMenu(modelKey: _modelKey)),
                                );
                              },
                            );
                          },
                          icon: const Icon(
                            Icons.menu,
                            size: 40,
                          ))
                    ],
                  ),
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              OutlinedButton.icon(
                onPressed: () {
                  audioViewModel.customPlayListPlayMusic(isShuffle: true, list: model.playList.toList());
                },
                icon: const Icon(Icons.shuffle, size: 18),
                label: const Text("shuffle"),
              ),
              OutlinedButton.icon(
                onPressed: () {
                  audioViewModel.customPlayListPlayMusic(isShuffle: false, list: model.playList.toList());
                },
                icon: const Icon(Icons.play_arrow, size: 18),
                label: const Text("play"),
              ),
            ],
          ),
          Expanded(
              child: model.playList.isNotEmpty
                  ? MusicListView(audioModel: model.playList)
                  : const Center(
                      child: Text('empty play list'),
                    )),
          AudioBarCheck(isBool: audioViewModel.mainState.playList.isNotEmpty),
        ],
      ),
    );
  }
}
