import 'package:audio_service/audio_service.dart';
import 'package:music_player/data/mapper/audio_model_mapper.dart';
import 'package:music_player/domain/model/audio_model.dart';
import 'package:music_player/domain/use_case/play_list/interface/add_song.dart';

class AddSongImpl implements AddSong {
  final AudioHandler _audioService;

  AddSongImpl({
    required AudioHandler audioService,
  }) : _audioService = audioService;

  @override
  void execute({required AudioModel model}) {
    _audioService.addQueueItem(model.toMediaItem());
  }

}