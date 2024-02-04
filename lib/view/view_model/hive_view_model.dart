import 'package:flutter/cupertino.dart';

import '../../domain/model/audio_model.dart';
import '../../domain/model/custom_play_list_model.dart';
import '../../domain/use_case/custom_play_list_box/interface/custom_play_list_data_check.dart';
import '../../domain/use_case/custom_play_list_box/interface/remove_custom_play_list.dart';
import '../../domain/use_case/custom_play_list_box/interface/custom_play_list_set_box.dart';
import '../../domain/use_case/custom_play_list_box/interface/custom_play_list_update_box.dart';
import '../../domain/use_case/custom_play_list_box/interface/get_custom_play_list.dart';

class HiveViewModel extends ChangeNotifier {
  List<CustomPlayListModel> _customPlayList = [];
  final List<AudioModel> _selectList = [];


  // useCase
  final CustomPlayListUpdateBox _customPlayListUpdateBox;
  final CustomPlayListSetBox _customPlayListSetBox;
  final RemoveCustomPlayList _removeCustomPlayList;
  final GetCustomPlayList _getCustomPlayList;
  final CustomPlayListDataCheck _customPlayListDataCheck;

// useCase

  HiveViewModel({
    required CustomPlayListUpdateBox customPlayListUpdateBox,
    required CustomPlayListSetBox customPlayListSetBox,
    required RemoveCustomPlayList removeCustomPlayList,
    required GetCustomPlayList getCustomPlayList,
    required CustomPlayListDataCheck customPlayListDataCheck,
  })  : _customPlayListUpdateBox = customPlayListUpdateBox,
        _customPlayListSetBox = customPlayListSetBox,
        _removeCustomPlayList = removeCustomPlayList,
        _customPlayListDataCheck = customPlayListDataCheck,
        _getCustomPlayList = getCustomPlayList{
    refreshPlayList();
  }

  List<AudioModel> get selectList => _selectList;
  List<CustomPlayListModel> get customPlayList => _customPlayList;

  int getIndex(int modelKey) {
    return customPlayList.map((e) => e.modelKey).toList().indexOf(modelKey);
  }

  void refreshPlayList() {
    _customPlayList = _getCustomPlayList.execute();
    notifyListeners();
  }

  void setPlayList({
    required String title,
    required List<AudioModel> playList,
  }) async {
    await _customPlayListSetBox.execute(title: title, playList: playList);
    refreshPlayList();
    notifyListeners();
  }

  void dataCheck() {
    _customPlayListDataCheck.execute();
  }

  void removePlayListSong({required int modelKey}) async {
    if(_selectList.isEmpty) return;
    final list = _customPlayList[getIndex(modelKey)];
    final playList = list.playList.toList();
    if (list.modelKey == null) return;

    for (AudioModel element in _selectList) {
      playList.remove(element);
    }
    await _customPlayListUpdateBox.execute(
        title: list.title,
        playList: playList,
        key: list.modelKey!);

    notifyListeners();
  }

  void removePlayList({required int modelKey}) async {
    _removeCustomPlayList.execute(key: modelKey);
    notifyListeners();
  }

  void addSongPlayList({required int modelKey}) async {
    if(_selectList.isEmpty) return;
    final list = _customPlayList[getIndex(modelKey)];
    if (list.modelKey == null) return;
    await _customPlayListUpdateBox.execute(
        title: list.title,
        playList: list.playList.toList()..addAll(_selectList),
        key: list.modelKey!);

    notifyListeners();
  }

  void selectMusic({required AudioModel audioModel}) {
    _selectList.contains(audioModel)
        ? _selectList.remove(audioModel)
        : _selectList.add(audioModel);
    notifyListeners();
  }

}