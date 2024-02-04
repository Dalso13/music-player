import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player/domain/model/audio_model.dart';
import 'package:music_player/domain/model/custom_play_list_model.dart';
import 'package:music_player/domain/repository/play_list_repository.dart';

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
  Box<CustomPlayListModel> get box => _box;

  @override
  List<CustomPlayListModel> get playList => _playList;

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
        playList: e1.playList.where((element) => data.contains(element)).toList()
      );
    }).toList();

    await _box.clear();
    await _box.addAll(newData);
    _getCustomPlayLists();
  }

  @override
  void setBox({
    required String title,
    required List<AudioModel> playList,
  }) async {
    int key =
        await box.add(CustomPlayListModel(title: title, playList: playList));
    box.put(key, CustomPlayListModel(title: title, playList: playList, modelKey: key));
  }

  @override
  Future<void> updateBox({required CustomPlayListModel model}) async {
    Hive.isAdapterRegistered(0);

    final data = box.get(model.modelKey);
    if (data != null){
      await box.put(model.modelKey, model);

    }
  }

  void deleteBox(dynamic key) {
    box.delete(key);
  }
}
