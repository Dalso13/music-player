import '../../../model/audio_model.dart';
import '../../../model/custom_play_list_model.dart';

abstract interface class CustomPlayListSetBox {
  Future<CustomPlayListModel> execute({required String title,
    required List<AudioModel> playList,});
}