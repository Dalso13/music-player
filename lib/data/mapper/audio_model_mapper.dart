import 'package:audio_service/audio_service.dart';

import '../../domain/model/audio_model.dart';

extension AudioModelmMapper on AudioModel {
  MediaItem toMediaItem() {
    return MediaItem(
      id: '$id',
      title: displayNameWOExt,
      artist: artist,
        extras: {'url': data},
      duration: Duration(milliseconds: duration),
    );
  }
}
