import 'package:audio_service/audio_service.dart';
import 'package:pristine_sound/data/mapper/audio_model_mapper.dart';
import '../../../model/audio_model.dart';
import '../interface/add_song.dart';

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