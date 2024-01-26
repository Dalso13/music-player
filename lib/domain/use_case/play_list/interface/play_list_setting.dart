import '../../../model/audio_model.dart';

abstract interface class PlayListSetting {
  Future<void> execute({required List<AudioModel> songList});
}
