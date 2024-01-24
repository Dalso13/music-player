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
      nullArtworkWidget: Image.network(
          'https://thumb.silhouette-ac.com/t/96/9629eae865b0d9e1725335c9985216a7_t.jpeg',
          // color: Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
          // colorBlendMode: BlendMode.lighten
        ),
      id: _audioId,
      type: ArtworkType.AUDIO,
    );
  }
}
