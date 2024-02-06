import 'package:on_audio_query/on_audio_query.dart';

import '../model/audio_model.dart';

abstract interface class SongRepository {
  OnAudioQuery get audioQuery;
  Future<List<AudioModel>> getAudioSource();
}