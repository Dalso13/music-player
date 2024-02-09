import 'package:flutter/material.dart';
import 'package:pristine_sound/view/ui/song_part/music_list_tile.dart';
import '../../../domain/model/audio_model.dart';

class MusicList extends StatelessWidget {
  final List<AudioModel> _audioModel;
  final int _currentId;
  final void Function({required AudioModel audioModel}) _onLongPress;
  final void Function({required AudioModel audioModel}) _playMusic;
  final void Function({required AudioModel audioModel}) _detailSongMenu;

  const MusicList({
    super.key,
    required List<AudioModel> audioModel,
    required int currentId,
    required void Function({required AudioModel audioModel}) onLongPress,
    required void Function({required AudioModel audioModel}) playMusic,
    required void Function({required AudioModel audioModel}) detailSongMenu,
  })  : _audioModel = audioModel,
        _currentId = currentId,
        _onLongPress = onLongPress,
        _playMusic = playMusic,
        _detailSongMenu = detailSongMenu;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: _audioModel.map((e) {
        bool isEqual = e.id == _currentId;
        return MusicListTile(
          isEqual: isEqual,
          audioModel: e,
          onLongPress: _onLongPress,
          playMusic: _playMusic,
          detailSongMenu: _detailSongMenu,
        );
      }).toList(),
    );
  }
}
