import 'package:hive_flutter/hive_flutter.dart';

import '../model/audio_model.dart';
import '../model/custom_play_list_model.dart';

abstract interface class PlayListRepository {
  void dataCheck();

  Box<CustomPlayListModel> get box;

  get playList;

  Future<void> updateBox({required CustomPlayListModel model});

  void setBox({
    required String title,
    required List<AudioModel> playList,
  });
}
