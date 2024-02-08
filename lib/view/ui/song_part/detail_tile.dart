import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../domain/model/audio_model.dart';
import '../audio_part/audio_image.dart';

class DetailTile extends StatelessWidget {
  final AudioModel _song;
  const DetailTile({super.key, required AudioModel song}): _song = song;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(_song.displayNameWOExt,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            maxLines: 1,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text(
          _song.artist,
          overflow: TextOverflow.ellipsis,
          softWrap: false,
          maxLines: 1,
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
        leading: AudioImage(audioId: _song.id),
      trailing: Text(
        DateFormat('mm:ss')
            .format(DateTime.fromMillisecondsSinceEpoch(_song.duration)),
        style: const TextStyle(color: Colors.grey),
      ),
    );
  }
}
