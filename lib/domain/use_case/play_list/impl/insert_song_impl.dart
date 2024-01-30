import 'package:audio_service/audio_service.dart';
import 'package:music_player/data/mapper/audio_model_mapper.dart';
import 'package:music_player/domain/model/audio_model.dart';
import 'package:music_player/domain/use_case/play_list/interface/insert_song.dart';

class InsertSongImpl implements InsertSong {
  final AudioHandler _audioService;

  InsertSongImpl({
    required AudioHandler audioService,
  }) : _audioService = audioService;

  @override
  void execute({required AudioModel model, required int index}) {
    _audioService.insertQueueItem(index, model.toMediaItem());
  }

}