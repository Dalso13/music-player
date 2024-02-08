import 'package:on_audio_query/on_audio_query.dart';

import '../model/audio_model.dart';

abstract interface class SongRepository {
  Future<List<AudioModel>> getAudioSource();
}