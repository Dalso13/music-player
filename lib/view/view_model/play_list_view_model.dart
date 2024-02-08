import 'package:flutter/cupertino.dart';

import '../../domain/model/audio_model.dart';
import '../../domain/use_case/custom_play_list_box/interface/custom_play_list_data_check.dart';
import '../../domain/use_case/custom_play_list_box/interface/remove_custom_play_list.dart';
import '../../domain/use_case/custom_play_list_box/interface/custom_play_list_set_box.dart';
import '../../domain/use_case/custom_play_list_box/interface/custom_play_list_update_box.dart';
import '../../domain/use_case/custom_play_list_box/interface/get_custom_play_list.dart';
import 'state/play_list_state.dart';

class PlayListViewModel extends ChangeNotifier {
  PlayListState _state = const PlayListState();
  final TextEditingController _textEditingController = TextEditingController();

  TextEditingController get textEditingController => _textEditingController;

  // useCase
  final CustomPlayListUpdateBox _customPlayListUpdateBox;
  final CustomPlayListSetBox _customPlayListSetBox;
  final RemoveCustomPlayList _removeCustomPlayList;
  final GetCustomPlayList _getCustomPlayList;
  final CustomPlayListDataCheck _customPlayListDataCheck;

// useCase

  PlayListViewModel({
    required CustomPlayListUpdateBox customPlayListUpdateBox,
    required CustomPlayListSetBox customPlayListSetBox,
    required RemoveCustomPlayList removeCustomPlayList,
    required GetCustomPlayList getCustomPlayList,
    required CustomPlayListDataCheck customPlayListDataCheck,
  })  : _customPlayListUpdateBox = customPlayListUpdateBox,
        _customPlayListSetBox = customPlayListSetBox,
        _removeCustomPlayList = removeCustomPlayList,
        _customPlayListDataCheck = customPlayListDataCheck,
        _getCustomPlayList = getCustomPlayList {
    refreshPlayList();
  }

  PlayListState get state => _state;

  int getIndex(int modelKey) {
    return _state.customPlayList
        .map((e) => e.modelKey)
        .toList()
        .indexOf(modelKey);
  }

  void refreshPlayList() {
    final list = _getCustomPlayList.execute();
    _state = _state.copyWith(customPlayList: list);
    notifyListeners();
  }

  void setPlayList() async {
    await _customPlayListSetBox.execute(title: _textEditingController.text, playList: []);
    refreshPlayList();
    notifyListeners();
  }

  void dataCheck() {
    _customPlayListDataCheck.execute();
  }

  void removePlayListSong({required int modelKey}) async {
    if (_state.selectList.isEmpty) return;
    final list = _state.customPlayList[getIndex(modelKey)];
    final playList = list.playList.toList();
    if (list.modelKey == null) return;

    for (AudioModel element in _state.selectList) {
      playList.remove(element);
    }
    await _customPlayListUpdateBox.execute(
        title: list.title, playList: playList, key: list.modelKey!);

    notifyListeners();
  }

  void removePlayList({required int modelKey}) async {
    _removeCustomPlayList.execute(key: modelKey);
    notifyListeners();
  }

  void addSongPlayList({required int modelKey}) async {
    if (_state.selectList.isEmpty) return;
    final list = _state.customPlayList[getIndex(modelKey)];
    if (list.modelKey == null) return;
    await _customPlayListUpdateBox.execute(
      title: list.title,
      playList: list.playList.toList()..addAll(_state.selectList),
      key: list.modelKey!,
    );

    notifyListeners();
  }

  void changeTitle({required int modelKey}) async {
    final list = _state.customPlayList[getIndex(modelKey)];
    await _customPlayListUpdateBox.execute(
      title: _textEditingController.text,
      playList: list.playList,
      key: list.modelKey!,
    );
    refreshPlayList();
    notifyListeners();
  }

  void selectMusic({required AudioModel audioModel}) {
    final List<AudioModel> list;
    if (_state.selectList.contains(audioModel)) {
      list = _state.selectList.toList()..remove(audioModel);
    } else {
      list = _state.selectList.toList()..add(audioModel);
    }
    _state = _state.copyWith(selectList: list);
    notifyListeners();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _textEditingController.dispose();
    super.dispose();
  }
}
