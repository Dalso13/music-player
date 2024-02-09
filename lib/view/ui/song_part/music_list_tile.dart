import 'package:flutter/material.dart';
import '../../../domain/model/audio_model.dart';
import 'song_tile.dart';

class MusicListTile extends StatelessWidget {
  final bool _isEqual;
  final AudioModel _audioModel;
  final void Function({required AudioModel audioModel}) _onLongPress;
  final void Function({required AudioModel audioModel}) _playMusic;
  final void Function({required AudioModel audioModel}) _detailSongMenu;

  const MusicListTile({
    super.key,
    required bool isEqual,
    required AudioModel audioModel,
    required void Function({required AudioModel audioModel}) onLongPress,
    required void Function({required AudioModel audioModel}) playMusic,
    required  void Function({required AudioModel audioModel}) detailSongMenu,
  })  : _isEqual = isEqual,
        _audioModel = audioModel,
        _onLongPress = onLongPress,
        _playMusic = playMusic,
        _detailSongMenu = detailSongMenu;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        _onLongPress(audioModel: _audioModel);
      },
      onTap: () {
        if (_isEqual) {
          return;
        }
        _playMusic(audioModel: _audioModel);
      },
      child: SongTile(song: _audioModel, isEqual: _isEqual, detailSongMenu: _detailSongMenu),
    );
  }
}
