import 'package:flutter/material.dart';
import 'package:pristine_sound/view/ui/custom_play_list/custom_play_list_menu/detail_play_list_icon.dart';
import 'package:provider/provider.dart';

import '../../view_model/audio_view_model.dart';
import '../../view_model/play_list_view_model.dart';
import '../audio_part/audio_image.dart';
import '../song_part/music_list_tile.dart';


class PlayListDetailScreen extends StatelessWidget {
  final int _modelKey;

  const PlayListDetailScreen({
    super.key,
    required int modelKey,
  }) : _modelKey = modelKey;

  @override
  Widget build(BuildContext context) {
    final AudioViewModel audioViewModel = context.watch<AudioViewModel>();
    final PlayListViewModel playListViewModel =
        context.watch<PlayListViewModel>();
    final model = playListViewModel
        .state.customPlayList[playListViewModel.getIndex(_modelKey)];
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            floating: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Column(
                children: [
                  SafeArea(
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                              left: 20, right: 20, bottom: 40, top: 40),
                          width: 200,
                          height: 200,
                          child: AudioImage(
                              audioId: model.playList.isEmpty
                                  ? 0
                                  : model.playList.first.id,
                              isPlayList: true),
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 200,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                DetailPlayListIcon(
                                  title: model.title,
                                  modelKey: model.modelKey!,
                                ),
                              ],
                            ),
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
                          audioViewModel.customPlayListPlayMusic(
                              isShuffle: true, list: model.playList.toList());
                        },
                        icon: const Icon(Icons.shuffle, size: 18),
                        label: const Text("shuffle"),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {
                          audioViewModel.customPlayListPlayMusic(
                              isShuffle: false, list: model.playList.toList());
                        },
                        icon: const Icon(Icons.play_arrow, size: 18),
                        label: const Text("play"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(model.playList.isNotEmpty
                ? model.playList.map((e) {
                    bool isEqual = e.id == audioViewModel.state.nowPlaySong.id;
                    return MusicListTile(isEqual: isEqual, audioModel: e);
                  }).toList()
                : [
                    const Center(
                      child: Text('empty play list'),
                    ),
                  ]),
          )
        ],
      ),
    );
  }
}
