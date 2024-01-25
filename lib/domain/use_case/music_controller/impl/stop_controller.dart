import 'package:music_player/data/repository/audio_repository_impl.dart';
import 'package:music_player/domain/use_case/music_controller/interface/music_controller.dart';

class StopController implements MusicController {
  final _audioRepository = AudioRepositoryImpl();

  @override
  Future<void> execute() async {
    if (_audioRepository.audioPlayer.playing) {
      await _audioRepository.audioPlayer.pause();
    }
  }

}