import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/model/audio_model.dart';
import '../../view_model/audio_view_model.dart';
import 'detail_song_menu.dart';
import 'song_tile.dart';

class MusicListTile extends StatelessWidget {
  final bool _isEqual;
  final AudioModel _audioModel;


  const MusicListTile({
    super.key,
    required bool isEqual,
    required AudioModel audioModel,
  })  : _isEqual = isEqual,
        _audioModel = audioModel;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AudioViewModel>();
    final state = viewModel.state;
    return GestureDetector(
      onLongPress: () {
        final myModel = Provider.of<AudioViewModel>(context, listen: false);
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
              builder: (context, scrollController) =>
                  ChangeNotifierProvider.value(
                    value: myModel,
                    child: DetailSongMenu(song: _audioModel),
                  ),
            );
          },
        );
      },
      onTap: () {
        if (_isEqual) {
          return;
        }
        viewModel.playMusic(index: state.songList.indexOf(_audioModel));
      },
      child: SongTile(song: _audioModel, isEqual: _isEqual),
    );
  }
}