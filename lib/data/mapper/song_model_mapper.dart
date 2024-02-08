import 'package:on_audio_query/on_audio_query.dart';

import '../../domain/model/audio_model.dart';

extension SongModelMapper on SongModel {
  AudioModel toMapper() {
    return AudioModel(displayNameWOExt: displayNameWOExt,
        artist: artist ?? 'No artist',
        duration: duration ?? 0,
        id: id,
        data: data);
  }
}