import 'package:audio_service/audio_service.dart';

import '../../domain/model/audio_model.dart';

extension MediaItemMapper on MediaItem {
  AudioModel toAudioModel() {
    return AudioModel(
        displayNameWOExt: title,
        artist: artist ?? 'No artist',
        duration: duration?.inMilliseconds ?? 0,
        id: int.parse(id),
        data: extras!['url'] ?? '');
  }
}
