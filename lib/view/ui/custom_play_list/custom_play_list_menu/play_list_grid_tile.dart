import 'package:flutter/material.dart';
import '../../../../domain/model/custom_play_list_model.dart';
import '../../audio_part/audio_image.dart';

class PlayListGridTile extends StatelessWidget {
  final CustomPlayListModel _model;
  final Function() _onPressed;
  final void Function() _refreshPlayList;

  const PlayListGridTile({
    super.key,
    required CustomPlayListModel model,
    required Function() onPressed,
    required void Function() refreshPlayList,
  })  : _model = model,
        _onPressed = onPressed,
        _refreshPlayList = refreshPlayList;

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
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30))),
                builder: (context) {
                  return DraggableScrollableSheet(
                    expand: false,
                    initialChildSize: 0.3,
                    builder: (context, scrollController) {
                      return _onPressed();
                    }
                  );
                },
              ).then((_) {
                _refreshPlayList();
              });
            },
            icon: const Icon(Icons.more_vert_outlined, color: Colors.white)),
      ),
      child: AudioImage(
          audioId: _model.playList.isEmpty ? 0 : _model.playList[0].id,
          isPlayList: true),
    );
  }
}
