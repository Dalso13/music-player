import '../model/custom_play_list_model.dart';

abstract interface class PlayListRepository {
  get playList;
  void dataCheck();
  Future<void> setPlayList({required CustomPlayListModel listModel});
  Future<void> updatePlayList({required CustomPlayListModel listModel, required int index});
  void removePlayList({required int index});
}
