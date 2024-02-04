
import 'package:music_player/domain/use_case/custom_play_list_box/interface/remove_custom_play_list.dart';

import '../../../repository/play_list_repository.dart';

class RemoveCustomPlayListImpl implements RemoveCustomPlayList{
  final PlayListRepository _playListRepository;

  const RemoveCustomPlayListImpl({
    required PlayListRepository playListRepository,
  }) : _playListRepository = playListRepository;

  @override
  void execute({required int key}) {
    _playListRepository.box.delete(key);
  }

}