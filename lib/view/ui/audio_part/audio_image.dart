import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AudioImage extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final _audioId;
  const AudioImage({super.key, required int audioId}): _audioId = audioId;

  @override
  Widget build(BuildContext context) {
    return QueryArtworkWidget(
      keepOldArtwork: true,
      nullArtworkWidget: Image.asset(
          'assets/images/art_image.png',
          // color: Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
          // colorBlendMode: BlendMode.lighten
        ),
      id: _audioId,
      type: ArtworkType.AUDIO,
    );
  }
}
