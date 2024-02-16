import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AudioImage extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final _audioId;
  final bool _isPlayList;

  const AudioImage({super.key, required int audioId, bool isPlayList = false})
      : _audioId = audioId,
        _isPlayList = isPlayList;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(40),
      child: QueryArtworkWidget(
        keepOldArtwork: true,
        nullArtworkWidget: Image.asset(_isPlayList
                ? 'assets/images/play_list_image.png'
                : 'assets/images/art_image.png'
            ),
        id: _audioId,
        type: ArtworkType.AUDIO,
      ),
    );
  }
}
