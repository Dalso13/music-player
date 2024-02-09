import '../../../model/audio_model.dart';

abstract interface class CustomPlayListUpdateBox {
  Future<void> execute({
    required int key,
    required String title,
    required List<AudioModel> playList,
    required int index,
  });
}
