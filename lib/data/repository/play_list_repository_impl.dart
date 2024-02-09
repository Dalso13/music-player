import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/model/custom_play_list_model.dart';
import '../../domain/repository/play_list_repository.dart';
import '../../domain/repository/song_repository.dart';

class PlayListRepositoryImpl implements PlayListRepository {
  late final Box<CustomPlayListModel> _box;
  List<CustomPlayListModel> _playList = [];
  final SongRepository _songRepository;

  PlayListRepositoryImpl({required SongRepository songRepository})
      : _songRepository = songRepository {
    _boxOpen();
    _getCustomPlayLists();
  }

  @override
  List<CustomPlayListModel> get playList {
    _getCustomPlayLists();
    return _playList;
  }

  void _getCustomPlayLists() {
    _playList = _box.values.toList();
  }

  void _boxOpen() async {
    if (Hive.isBoxOpen('customPlayList')) {
      _box = Hive.box<CustomPlayListModel>('customPlayList');
    } else {
      _box = await Hive.openBox<CustomPlayListModel>('customPlayList');
    }
  }

  @override
  void dataCheck() async {
    final data = await _songRepository.getAudioSource();
    final newData = _playList.map((e1) {
      return CustomPlayListModel(
          title: e1.title,
          modelKey: e1.modelKey,
          playList:
              e1.playList.where((element) => data.contains(element)).toList());
    }).toList();

    await _box.clear();
    await _box.addAll(newData);
    _getCustomPlayLists();
  }

  @override
  Future<void> setPlayList(
      {required CustomPlayListModel listModel}) async {
    int key = await _box.add(CustomPlayListModel(
      title: listModel.title,
      playList: listModel.playList,
    ));
    final model = CustomPlayListModel(
        title: listModel.title, playList: listModel.playList, modelKey: key);
    await _box.put(key, model);

  }

  @override
  Future<void> updatePlayList({required CustomPlayListModel listModel, required int index,}) async {
    final data = _box.get(listModel.modelKey);
    if (data != null) {
      await _box.putAt(
        index,
        CustomPlayListModel(
          title: listModel.title,
          playList: listModel.playList,
          modelKey: listModel.modelKey,
        ),
      );
    }
  }
  @override
  void removePlayList({required int index}) async {
    await _box.deleteAt(index);
  }

}
