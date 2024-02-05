import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:music_player/domain/model/audio_model.dart';
import 'package:provider/provider.dart';

import '../../view_model/audio_view_model.dart';
import '../audio_part/audio_image.dart';
import 'detail_song_menu.dart';

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
      title: Text(_song.displayNameWOExt,
          overflow: TextOverflow.ellipsis,
          softWrap: false,
          maxLines: 1,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _song.artist,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            maxLines: 1,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
          Text(
            DateFormat('mm:ss')
                .format(DateTime.fromMillisecondsSinceEpoch(_song.duration)),
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            maxLines: 1,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
      leading: AudioImage(audioId: _song.id),
      trailing: IconButton(
        onPressed: () {
          final myModel = Provider.of<AudioViewModel>(context, listen: false);
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
            builder: (context) {
              return DraggableScrollableSheet(
                expand: false,
                initialChildSize: 0.3,
                builder: (context, scrollController) =>
                    ChangeNotifierProvider.value(
                  value: myModel,
                  child: DetailSongMenu(song: _song),
                ),
              );
            },
          );
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
