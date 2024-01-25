import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/data/repository/audio_repository_impl.dart';
import '../interface/repeat_change.dart';

class RepeatChangeImpl implements RepeatChange{
  final AudioRepositoryImpl _audioRepository = AudioRepositoryImpl();

  @override
  void execute(AudioServiceRepeatMode repeatMode) {
    switch(repeatMode){
      case AudioServiceRepeatMode.none:
        _audioRepository.audioPlayer.setLoopMode(LoopMode.off);
        break;
      case AudioServiceRepeatMode.one:
        _audioRepository.audioPlayer.setLoopMode(LoopMode.one);
        break;
      case AudioServiceRepeatMode.group:
      case AudioServiceRepeatMode.all:
      _audioRepository.audioPlayer.setLoopMode(LoopMode.all);
        break;
    }
  }

}