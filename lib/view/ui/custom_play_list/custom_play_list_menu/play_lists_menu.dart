import 'package:flutter/material.dart';
import 'package:pristine_sound/view/ui/custom_play_list/custom_play_list_menu/play_lists_dialog.dart';
import 'package:provider/provider.dart';

import '../../../view_model/play_list_view_model.dart';

class PlayListsMenu extends StatelessWidget {
  final int _index;
  final String _title;

  const PlayListsMenu({
    super.key,
    required int index,
    required String title,
  })  : _index = index,
        _title = title;

  @override
  Widget build(BuildContext context) {
    final PlayListViewModel playListViewModel = context.watch<PlayListViewModel>();
    return SingleChildScrollView(
      child: SizedBox(
        width: double.maxFinite,
        child: Column(
          children: [
            // TODO: Remove 이슈 떔에 막아둠
            InkWell(
              onTap: () async {
                showDialog(
                  context: context,
                  barrierDismissible: true, //바깥 영역 터치시 닫을지 여부 결정
                  builder: ((context) {
                    return AlertDialog(
                      title: const Text("you want delete it?"),
                      actions: <Widget>[
                        ElevatedButton(
                          onPressed: () {
                            playListViewModel.removePlayList(index: _index);
                            Navigator.of(context).pop(); //창 닫기
                          },
                          child: const Text("yes"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(); //창 닫기
                          },
                          child: const Text("no"),
                        ),
                      ],
                    );
                  }),
                ).then((_) {
                  Navigator.of(context).pop();
                });
              },
              child: Container(
                margin: const EdgeInsets.all(8),
                width: double.maxFinite,
                child: const Row(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.only(top: 8, right: 16, left: 16, bottom: 8),
                      child: Icon(Icons.playlist_remove, size: 32),
                    ),
                    Text(
                      'remove playList',
                      style: TextStyle(fontSize: 14),
                    )
                  ],
                ),
              ),
            ),
            const Divider(
              height: 1,
              thickness: 1,
            ),
            InkWell(
              onTap: () async {
                playListViewModel.textEditingController.text = _title;
                showDialog(
                  context: context,
                  builder: (context) {
                    return ChangeNotifierProvider.value(
                        value: playListViewModel,
                        child: PlayListsDialog(
                          index: _index,
                        ));
                  },
                ).then((value) {
                  playListViewModel.textEditingController.text = '';
                });
              },
              child: Container(
                margin: const EdgeInsets.all(8),
                width: double.maxFinite,
                child: const Row(
                  children: [
                    Padding(
                      padding:
                      EdgeInsets.only(top: 8, right: 16, left: 16, bottom: 8),
                      child: Icon(Icons.border_color, size: 28),
                    ),
                    Text(
                      'change title',
                      style: TextStyle(fontSize: 14),
                    )
                  ],
                ),
              ),
            ),
            const Divider(
              height: 1,
              thickness: 1,
            ),
          ],
        ),
      ),
    );
  }
}


