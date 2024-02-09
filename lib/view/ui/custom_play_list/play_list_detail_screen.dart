import 'package:flutter/material.dart';
import 'package:pristine_sound/view/ui/custom_play_list/custom_play_list_menu/detail_play_list_icon.dart';
import 'package:provider/provider.dart';

import '../../../domain/model/audio_model.dart';
import '../../view_model/audio_view_model.dart';
import '../../view_model/play_list_view_model.dart';
import '../audio_part/audio_bar_check.dart';
import '../audio_part/audio_image.dart';
import '../song_part/detail_song_menu.dart';
import '../song_part/music_list_tile.dart';
import 'custom_play_list_menu/only_one_play_list_menu.dart';
import 'custom_play_list_menu/play_lists_dialog.dart';

class PlayListDetailScreen extends StatelessWidget {
  final int _index;

  const PlayListDetailScreen({
    super.key,
    required int index,
  }) : _index = index;

  @override
  Widget build(BuildContext context) {
    final isSize = MediaQuery.of(context).size.width < 380;
    final AudioViewModel audioViewModel = context.watch<AudioViewModel>();
    final state = audioViewModel.state;
    final PlayListViewModel playListViewModel =
        context.watch<PlayListViewModel>();
    final model = playListViewModel
        .state.customPlayList[_index];
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
                            width: isSize ? 100 : 200,
                            height: isSize ? 100 : 200,
                            child: AudioImage(
                                audioId: model.playList.isEmpty
                                    ? 0
                                    : model.playList.first.id,
                                isPlayList: true),
                          ),
                          Expanded(
                            child: SizedBox(
                              height: isSize ? 100 : 200,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                    changeTitle: () {
                                      playListViewModel.textEditingController
                                          .text = model.title;
                                      return ChangeNotifierProvider.value(
                                        value: playListViewModel,
                                        child: PlayListsDialog(
                                          index: _index,
                                        ),
                                      );
                                    },
                                    viewMenu: () {
                                      return ChangeNotifierProvider.value(
                                        value: playListViewModel,
                                        child: OnlyOnePlayListMenu(
                                          index: _index,
                                        ),
                                      );
                                    },
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
                                isShuffle: false,
                                list: model.playList.toList());
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
              delegate: SliverChildListDelegate(
                model.playList.isNotEmpty
                    ? model.playList.map((e) {
                        bool isEqual =
                            e.id == audioViewModel.state.nowPlaySong.id;
                        return MusicListTile(
                          audioModel: e,
                          playMusic: ({required AudioModel audioModel}) {
                            audioViewModel.playMusic(
                                index: state.songList.indexOf(audioModel));
                          },
                          onLongPress: ({required AudioModel audioModel}) {
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
                                      ChangeNotifierProvider.value(
                                    value: audioViewModel,
                                    child: DetailSongMenu(song: audioModel),
                                  ),
                                );
                              },
                            );
                          },
                          isEqual: isEqual,
                          detailSongMenu: ({required AudioModel audioModel}) {
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
                                      ChangeNotifierProvider.value(
                                    value: audioViewModel,
                                    child: DetailSongMenu(song: audioModel),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      }).toList()
                    : [
                        const Center(
                          child: Text('empty play list'),
                        ),
                      ],
              ),
            ),
          ],
        ),
        bottomNavigationBar:
            const SizedBox(height: 90, child: AudioBarCheck()));
  }
}
