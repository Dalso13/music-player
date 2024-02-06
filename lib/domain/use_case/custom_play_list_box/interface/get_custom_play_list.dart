import 'package:music_player/domain/model/custom_play_list_model.dart';
abstract interface class GetCustomPlayList {
  List<CustomPlayListModel> execute();
}