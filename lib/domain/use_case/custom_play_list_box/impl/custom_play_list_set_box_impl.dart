
import '../../../model/audio_model.dart';
import '../../../model/custom_play_list_model.dart';
import '../../../repository/play_list_repository.dart';
import '../interface/custom_play_list_set_box.dart';

class CustomPlayListSetBoxImpl implements CustomPlayListSetBox{
  final PlayListRepository _playListRepository;

  const CustomPlayListSetBoxImpl({
    required PlayListRepository playListRepository,
  }) : _playListRepository = playListRepository;

  @override
  Future<void> execute({required String title,
    required List<AudioModel> playList,}) async{

    await _playListRepository.setPlayList(listModel: CustomPlayListModel(
        title: title, playList: playList));
  }

}