import 'package:audio_service/audio_service.dart';
import 'package:music_player/data/repository/audio_repository_impl.dart';
import 'package:music_player/domain/use_case/music_controller/interface/music_controller.dart';

class StopController implements MusicController {
  final AudioHandler _audioService;

  StopController({
    required AudioHandler audioService,
  }) : _audioService = audioService;

  @override
  Future<void> execute() async {
    await _audioService.pause();
  }

}