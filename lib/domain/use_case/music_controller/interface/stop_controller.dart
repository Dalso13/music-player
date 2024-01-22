import 'package:music_player/data/reposiotry/audio_repository.dart';
import 'package:music_player/domain/use_case/music_controller/impl/music_controller.dart';

class StopController implements MusicController {
  final _audioRepository = AudioRepository();

  @override
  void execute() async {
    if (_audioRepository.audioPlayer.playing) {
      await _audioRepository.audioPlayer.pause();
    }
  }

}