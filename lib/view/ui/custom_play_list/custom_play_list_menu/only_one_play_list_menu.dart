import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../view_model/play_list_model.dart';

class OnlyOnePlayListMenu extends StatelessWidget {
  final int _modelKey;
  const OnlyOnePlayListMenu({
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
                await context.push('/custom-play-list/add-music', extra: _modelKey);
                hiveViewModel.refreshPlayList();
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
                      'add music',
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
                await context.push('/custom-play-list/remove-music', extra: _modelKey);
                hiveViewModel.refreshPlayList();
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
                      'remove music',
                      style: TextStyle(fontSize: 14),
                    )
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
