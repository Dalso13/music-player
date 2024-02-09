import '../../../model/audio_model.dart';

abstract interface class CustomPlayListSetBox {
  Future<void> execute({required String title,
    required List<AudioModel> playList,});
}