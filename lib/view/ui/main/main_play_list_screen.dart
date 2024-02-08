import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../view_model/play_list_view_model.dart';
import '../custom_play_list/custom_play_list_menu/play_list_grid_tile.dart';
import '../custom_play_list/custom_play_list_menu/play_lists_dialog.dart';

class MainPlayListScreen extends StatelessWidget {
  const MainPlayListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PlayListViewModel playListViewModel =
        context.watch<PlayListViewModel>();
    final playListState = playListViewModel.state;
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () {
                final viewModel =
                    Provider.of<PlayListViewModel>(context, listen: false);
                showDialog(
                  context: context,
                  builder: (context) {
                    return ChangeNotifierProvider.value(
                        value: viewModel, child: const PlayListsDialog());
                  },
                );
              },
              icon: const Icon(Icons.add),
            ),
            const Text('New Play List')
          ],
        ),
        const Divider(
          height: 1,
          thickness: 1,
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              playListViewModel.refreshPlayList();
            },
            child: GridView.count(
              padding: const EdgeInsets.all(20),
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              crossAxisCount: 2,
              children: playListState.customPlayList
                  .map((e) => GestureDetector(
                      onTap: () async {
                        await context.push('/custom-play-list',
                            extra: playListViewModel.getIndex(e.modelKey!));
                        playListViewModel.refreshPlayList();
                      },
                      child: PlayListGridTile(
                        model: e,
                      )))
                  .toList(),
            ),
          ),
        )
      ],
    );
  }
}
