
import '../../../model/custom_play_list_model.dart';
import '../../../repository/play_list_repository.dart';
import '../interface/get_custom_play_list.dart';

class GetCustomPlayListImpl implements GetCustomPlayList {
  final PlayListRepository _playListRepository;

  const GetCustomPlayListImpl({
    required PlayListRepository playListRepository,
  }) : _playListRepository = playListRepository;

  @override
  List<CustomPlayListModel> execute() {
    return _playListRepository.box.values.toList();
  }
}