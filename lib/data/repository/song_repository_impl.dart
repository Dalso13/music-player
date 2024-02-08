import 'package:on_audio_query/on_audio_query.dart';
import 'package:pristine_sound/data/mapper/song_model_mapper.dart';
import '../../domain/model/audio_model.dart';
import '../../domain/repository/song_repository.dart';

class SongRepositoryImpl implements SongRepository {
  final OnAudioQuery _audioQuery = OnAudioQuery();

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