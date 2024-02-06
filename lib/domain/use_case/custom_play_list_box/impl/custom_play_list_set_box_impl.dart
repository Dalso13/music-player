import 'package:music_player/domain/use_case/custom_play_list_box/interface/custom_play_list_set_box.dart';

import '../../../model/audio_model.dart';
import '../../../model/custom_play_list_model.dart';
import '../../../repository/play_list_repository.dart';

class CustomPlayListSetBoxImpl implements CustomPlayListSetBox{
  final PlayListRepository _playListRepository;

  const CustomPlayListSetBoxImpl({
    required PlayListRepository playListRepository,
  }) : _playListRepository = playListRepository;

  @override
  Future<CustomPlayListModel> execute({required String title,
    required List<AudioModel> playList,}) async{

    int key = await _playListRepository.box.add(CustomPlayListModel(
        title: title, playList: playList));

    final model = CustomPlayListModel(
        title: title, playList: playList, modelKey: key);
    await _playListRepository.box.put(key, model);

    return model;
  }

}