import 'package:music_player/data/repository/audio_repository_impl.dart';
import 'package:music_player/domain/use_case/music_controller/interface/music_controller.dart';

class PreviousPlayController implements MusicController {
  final _audioRepository = AudioRepositoryImpl();

  @override
  Future<void> execute() async {
    await _audioRepository.audioPlayer.seekToPrevious();
  }

}