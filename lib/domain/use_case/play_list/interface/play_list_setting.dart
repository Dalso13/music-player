import 'package:on_audio_query/on_audio_query.dart';

abstract interface class PlayListSetting {
  Future<List<SongModel>> execute({required int index , required List<SongModel> songList});
}