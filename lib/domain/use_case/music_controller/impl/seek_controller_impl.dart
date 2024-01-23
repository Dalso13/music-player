import '../../../../data/reposiotry/audio_repository.dart';
import '../interface/seek_controller.dart';

class SeekControllerImpl implements SeekController {
  final _audioRepository = AudioRepository();

  @override
  void execute({required Duration position}) {
    _audioRepository.audioPlayer.seek(position);
  }



}