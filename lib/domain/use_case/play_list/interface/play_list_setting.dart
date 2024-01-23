import '../../../model/audio_model.dart';

abstract interface class PlayListSetting {
  Future<List<AudioModel>> execute(
      {required int index, required List<AudioModel> songList});
}
