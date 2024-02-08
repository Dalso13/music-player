import 'package:flutter/material.dart';
import 'package:pristine_sound/view/ui/song_part/music_list_tile.dart';
import 'package:provider/provider.dart';

import '../../../domain/model/audio_model.dart';
import '../../view_model/audio_view_model.dart';

class MusicList extends StatelessWidget {
  final List<AudioModel> audioModel;

  const MusicList({
    super.key,
    required this.audioModel,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AudioViewModel>();
    final state = viewModel.state;
    return ListView(
      children: audioModel.map((e) {
        bool isEqual = e.id == state.nowPlaySong.id;
        return MusicListTile(isEqual: isEqual, audioModel: e);
      }).toList(),
    );
  }
}
