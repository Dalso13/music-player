import 'package:audio_service/audio_service.dart';
import '../interface/music_controller.dart';

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