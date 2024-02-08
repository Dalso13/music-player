import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../view_model/play_list_view_model.dart';

class PlayListsDialog extends StatelessWidget {
  final int? _modalKey;

  const PlayListsDialog({super.key, int? modalKey})
      : _modalKey = modalKey;

  @override
  Widget build(BuildContext context) {
    final PlayListViewModel playListViewModel =
        context.watch<PlayListViewModel>();
    return AlertDialog(
      title: Text(_modalKey != null ? "change title" : "new play list" ),
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

            if (_modalKey == null) {
              playListViewModel.setPlayList();
            } else {
              playListViewModel.changeTitle(modelKey: _modalKey);
            }
            context.pop();
            playListViewModel.textEditingController.text = '';
          },
          child: Text(_modalKey != null ? "set" : "create"),
        ),
      ],
    );
  }
}
