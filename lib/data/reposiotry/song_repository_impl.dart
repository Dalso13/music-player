import 'package:music_player/data/mapper/song_model_mapper.dart';
import 'package:music_player/data/reposiotry/song_repository.dart';
import 'package:music_player/domain/model/audio_model.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../source/audio_source.dart';

class SongRepositoryImpl implements SongRepository {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  @override
  OnAudioQuery get audioQuery => _audioQuery;

  @override
  Future<List<AudioModel>> getAudioSource() async {
    final songModelList = await _audioQuery.querySongs(
      sortType: null,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );

    return songModelList.map((e) => e.toMapper()).toList();
  }


}