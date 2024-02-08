import 'package:audio_service/audio_service.dart';
import '../interface/music_controller.dart';

class PreviousPlayController implements MusicController {
  final AudioHandler _audioService;

  PreviousPlayController({
    required AudioHandler audioService,
  }) : _audioService = audioService;

  @override
  Future<void> execute() async {
    await _audioService.skipToPrevious();
  }

}