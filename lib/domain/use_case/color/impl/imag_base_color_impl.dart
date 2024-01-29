import 'package:flutter/cupertino.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:palette_generator/palette_generator.dart';

import '../interface/imag_base_color.dart';

class ImageBaseColorImpl implements ImageBaseColor {
  @override
  Future<int> execute({required int id}) async {
    final bytes = await OnAudioQuery().queryArtwork(
      id,
      ArtworkType.AUDIO,
    );
    final image;
    if (bytes == null) {
      image = AssetImage('assets/images/art_image.jpeg');
    } else {
      image = MemoryImage(bytes);
    }

    final PaletteGenerator generator = await
    PaletteGenerator.fromImageProvider(
        image
    );

    PaletteColor? color = generator.lightMutedColor;

    return color == null ? 0xff000000 : color.color.value;
  }

}