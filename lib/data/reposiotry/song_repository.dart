import 'package:on_audio_query/on_audio_query.dart';

abstract interface class SongRepository {
  OnAudioQuery get audioQuery;
  Future<List<SongModel>> getAudioSource();
}