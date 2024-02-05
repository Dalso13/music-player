import 'package:music_player/domain/model/custom_play_list_model.dart';

import '../../../model/audio_model.dart';
import '../../../repository/play_list_repository.dart';
import '../interface/custom_play_list_update_box.dart';

class CustomPlayListUpdateBoxImpl implements CustomPlayListUpdateBox {
  final PlayListRepository _playListRepository;

  const CustomPlayListUpdateBoxImpl({
    required PlayListRepository playListRepository,
  }) : _playListRepository = playListRepository;

  @override
  Future<void> execute({
    required int key,
    required String title,
    required List<AudioModel> playList,
  }) async {
    final data = _playListRepository.box.get(key);
    if (data != null){
      await _playListRepository.box.put(key , CustomPlayListModel(
          title: title, playList: playList, modelKey: key));
    }
  }
}
