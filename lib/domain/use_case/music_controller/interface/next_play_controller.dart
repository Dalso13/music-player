import 'package:music_player/data/reposiotry/audio_repository.dart';
import 'package:music_player/domain/use_case/music_controller/impl/music_controller.dart';

class NextPlayController implements MusicController {
  final _audioRepository = AudioRepository();

  @override
  void execute() async {
    await _audioRepository.audioPlayer.seekToNext();
  }

}