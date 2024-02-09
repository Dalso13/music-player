import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../domain/model/audio_model.dart';
import '../audio_part/audio_image.dart';

class SongTile extends StatelessWidget {
  final AudioModel _song;
  final bool _isEqual;
  final void Function({required AudioModel audioModel}) _detailSongMenu;

  const SongTile({
    super.key,
    required void Function({required AudioModel audioModel}) detailSongMenu,
    required AudioModel song,
    required bool isEqual,
  })  : _detailSongMenu = detailSongMenu,
        _song = song,
        _isEqual = isEqual;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: _isEqual ? Colors.grey[300]!.withOpacity(0.7) : null,
      title: Text(_song.displayNameWOExt,
          overflow: TextOverflow.ellipsis,
          softWrap: false,
          maxLines: 1,
          style: const TextStyle(fontSize: 14)),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _song.artist,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomRight,
              child: Text(
                DateFormat('mm:ss').format(
                    DateTime.fromMillisecondsSinceEpoch(_song.duration)),
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                maxLines: 1,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
      leading: AudioImage(audioId: _song.id),
      trailing: IconButton(
        onPressed: () {
            _detailSongMenu(audioModel: _song);
        },
        icon: Icon(
          Icons.more_vert_outlined,
          color: Colors.grey[500],
          size: 20,
        ),
      ),
    );
  }
}
