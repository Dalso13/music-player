import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:music_player/view/ui/custom_play_list/custom_play_list_menu/play_list_grid_tile.dart';
import 'package:music_player/view/view_model/audio_view_model.dart';
import 'package:music_player/view/view_model/hive_view_model.dart';
import 'package:music_player/view/view_model/main_view_model.dart';
import 'package:provider/provider.dart';

class MainPlayListScreen extends StatelessWidget {
  const MainPlayListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final MainViewModel mainViewModel = context.watch<MainViewModel>();
    final HiveViewModel hiveViewModel = context.watch<HiveViewModel>();
    return Column(
      children: [
        Row(
          children: [
            Container(
              child: IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("new play list"),
                          content: TextField(
                            controller: mainViewModel.textEditingController,
                            decoration: InputDecoration(
                              labelText: 'Title',
                            ),
                            maxLength: 20,
                            maxLines: 1,
                          ),
                          actions: <Widget>[
                            Container(
                              child: TextButton(
                                onPressed: () {
                                  context.pop();
                                },
                                child: Text("닫기"),
                              ),
                            ),
                            Container(
                              child: TextButton(
                                onPressed: () {
                                  if (mainViewModel
                                          .textEditingController.text ==
                                      '') return;
                                  hiveViewModel.setPlayList(
                                    title: mainViewModel
                                        .textEditingController.text,
                                    playList: [],
                                  );
                                  context.pop();
                                },
                                child: Text("만들기"),
                              ),
                            ),
                          ],
                        );
                      });
                },
                icon: Icon(Icons.add),
              ),
            ),
            Text('New Play List')
          ],
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              hiveViewModel.refreshPlayList();
            },
            child: GridView.count(
                padding: const EdgeInsets.all(20),
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                crossAxisCount: 2,
                children: hiveViewModel.customPlayList
                    .map((e) => GestureDetector(
                        onTap: () async {
                          await context.push('/custom-play-list', extra:  hiveViewModel.getIndex(e.modelKey!));
                          hiveViewModel.refreshPlayList();
                        },
                        child: PlayListGridTile(
                          model: e,
                        )))
                    .toList()),
          ),
        )
      ],
    );
  }
}
