import 'package:on_audio_query/on_audio_query.dart';

abstract interface class ShufflePlayListSetting {
  Future<List<SongModel>> execute({required List<SongModel> songList});
}