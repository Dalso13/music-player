import 'package:hive_flutter/hive_flutter.dart';
import '../model/custom_play_list_model.dart';

abstract interface class PlayListRepository {
  void dataCheck();

  Box<CustomPlayListModel> get box;

  get playList;
}
