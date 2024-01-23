import 'package:music_player/data/reposiotry/audio_repository.dart';
import 'package:music_player/domain/use_case/music_controller/interface/music_controller.dart';

class PlayController implements MusicController {
  final _audioRepository = AudioRepository();

  @override
  void execute() async {
    await _audioRepository.audioPlayer.play();
  }

}