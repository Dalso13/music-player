import '../../../model/audio_model.dart';

abstract interface class ShufflePlayListSetting {
  Future<List<AudioModel>> execute({required List<AudioModel> songList});
}
