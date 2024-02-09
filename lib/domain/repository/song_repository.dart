import '../model/audio_model.dart';

abstract interface class SongRepository {
  Future<List<AudioModel>> getAudioSource();
}