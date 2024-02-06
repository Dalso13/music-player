import 'package:music_player/domain/model/custom_play_list_model.dart';
import 'package:music_player/domain/use_case/custom_play_list_box/interface/custom_play_list_data_check.dart';
import 'package:music_player/domain/use_case/custom_play_list_box/interface/get_custom_play_list.dart';

import '../../../repository/play_list_repository.dart';

class CustomPlayListDataCheckImpl implements CustomPlayListDataCheck {
  final PlayListRepository _playListRepository;

  const CustomPlayListDataCheckImpl({
    required PlayListRepository playListRepository,
  }) : _playListRepository = playListRepository;

  @override
  void execute() {
    _playListRepository.dataCheck();
  }
}