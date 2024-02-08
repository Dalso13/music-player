import 'package:audio_service/audio_service.dart';
import '../interface/music_controller.dart';

class NextPlayController implements MusicController {
  final AudioHandler _audioService;

  NextPlayController({
    required AudioHandler audioService,
  }) : _audioService = audioService;

  @override
  Future<void> execute() async {
    await _audioService.skipToNext();
  }

}