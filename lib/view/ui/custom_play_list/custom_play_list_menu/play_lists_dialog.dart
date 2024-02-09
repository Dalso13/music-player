import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../view_model/play_list_view_model.dart';

class PlayListsDialog extends StatelessWidget {
  final int? _index;

  const PlayListsDialog({super.key, int? index})
      : _index = index;

  @override
  Widget build(BuildContext context) {
    final PlayListViewModel playListViewModel =
        context.watch<PlayListViewModel>();
    return AlertDialog(
      title: Text(_index != null ? "change title" : "new play list" ),
      content: TextField(
        controller: playListViewModel.textEditingController,
        decoration: const InputDecoration(
          labelText: 'Title',
        ),
        maxLength: 20,
        maxLines: 1,
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            context.pop();
          },
          child: const Text("close"),
        ),
        TextButton(
          onPressed: () {
            if (playListViewModel.textEditingController.text == '') return;

            if (_index == null) {
              playListViewModel.setPlayList();
            } else {
              playListViewModel.changeTitle(index: _index);
            }
            context.pop();
            playListViewModel.textEditingController.text = '';
          },
          child: Text(_index != null ? "set" : "create"),
        ),
      ],
    );
  }
}
