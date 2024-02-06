import 'package:music_player/domain/model/custom_play_list_model.dart';
import 'package:music_player/domain/use_case/custom_play_list_box/interface/get_custom_play_list.dart';

import '../../../repository/play_list_repository.dart';

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