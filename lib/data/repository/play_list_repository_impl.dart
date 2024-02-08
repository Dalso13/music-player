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
}
