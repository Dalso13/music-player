import '../../../repository/play_list_repository.dart';
import '../interface/custom_play_list_data_check.dart';

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