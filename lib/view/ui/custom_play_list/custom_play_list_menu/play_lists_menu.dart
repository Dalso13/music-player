import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../view_model/play_list_model.dart';

class PlayListsMenu extends StatelessWidget {
  final int _modelKey;
  const PlayListsMenu({
    super.key, required int modelKey,
  }) : _modelKey = modelKey;

  @override
  Widget build(BuildContext context) {
    final PlayListViewModel hiveViewModel = context.watch<PlayListViewModel>();
    return SingleChildScrollView(
      child: SizedBox(
        width: double.maxFinite,
        child: Column(
          children: [
            InkWell(
              onTap: () async {
                showDialog(
                  context: context,
                  barrierDismissible: true, //바깥 영역 터치시 닫을지 여부 결정
                  builder: ((context) {
                    return AlertDialog(
                      title: const Text("you want delete it?"),
                      actions: <Widget>[
                        Container(
                          child: ElevatedButton(
                            onPressed: () {
                              hiveViewModel.removePlayList(modelKey: _modelKey);
                              Navigator.of(context).pop(); //창 닫기
                            },
                            child: const Text("yes"),
                          ),
                        ),
                        Container(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop(); //창 닫기
                            },
                            child: const Text("no"),
                          ),
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
                      child: Icon(Icons.playlist_add, size: 32),
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
          ],
        ),
      ),
    );
  }
}
