import '../../../../data/repository/audio_repository_impl.dart';
import '../interface/seek_controller.dart';

class SeekControllerImpl implements SeekController {
  final _audioRepository = AudioRepositoryImpl();

  @override
  void execute({required Duration position}) {
    _audioRepository.audioPlayer.seek(position);
  }



}