import 'package:flutter/material.dart';
import 'package:music_player/view/ui/custom_play_list/custom_play_list_menu/play_lists_menu.dart';
import 'package:provider/provider.dart';

import '../../../../domain/model/custom_play_list_model.dart';
import '../../../view_model/hive_view_model.dart';
import '../../audio_part/audio_image.dart';

class PlayListGridTile extends StatelessWidget {
  final CustomPlayListModel _model;

  const PlayListGridTile({
    super.key,
    required CustomPlayListModel model,
  }) : _model = model;

  @override
  Widget build(BuildContext context) {
    return GridTile(
      footer: GridTileBar(
        backgroundColor: Colors.black54,
        title: Text(
          _model.title,
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.ellipsis),
        ),
        trailing: IconButton(
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
                          child: PlayListsMenu(modelKey: _model.modelKey ?? -1)),
                );
              },
            ).then((_) {
              context.read<HiveViewModel>().refreshPlayList();
            });
          },
          icon: const Icon(Icons.more_vert_outlined, color: Colors.white)
        ),
      ),
      child: Container(
        child: AudioImage(
            audioId: _model.playList.isEmpty ? 0 : _model.playList[0].id),
      ),
    );
  }
}
