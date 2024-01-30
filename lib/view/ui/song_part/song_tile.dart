import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:music_player/domain/model/audio_model.dart';
import 'package:provider/provider.dart';

import '../../view_model/main_view_model.dart';
import '../audio_part/audio_image.dart';
import 'detail_song_control.dart';

class SongTile extends StatelessWidget {
  final AudioModel _song;
  final bool _isEqual;

  const SongTile({super.key, required AudioModel song, required bool isEqual})
      : _song = song,
        _isEqual = isEqual;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: _isEqual ? Colors.grey[200]!.withOpacity(0.6) : null,
      title: Text(
          _song.displayNameWOExt,
          overflow: TextOverflow.ellipsis,
          softWrap: false,
          maxLines: 1,
          style:
          const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      subtitle: Text(
        _song.artist,
        overflow: TextOverflow.ellipsis,
        softWrap: false,
        maxLines: 1,
        style: const TextStyle(color: Colors.grey, fontSize: 12),
      ),
      leading: AudioImage(audioId: _song.id),
      trailing: Text(
          DateFormat('mm:ss').format(
              DateTime.fromMillisecondsSinceEpoch(_song.duration)),
          style: const TextStyle(color: Colors.grey)),
    );
  }
}
