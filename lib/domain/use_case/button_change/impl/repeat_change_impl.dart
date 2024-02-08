import 'package:audio_service/audio_service.dart';
import '../../../../core/repeat_state.dart';
import '../interface/repeat_change.dart';

class RepeatChangeImpl implements RepeatChange{
  final AudioHandler _audioService;

  RepeatChangeImpl({
    required AudioHandler audioService,
  }) : _audioService = audioService;


  @override
  RepeatState execute(RepeatState repeatMode) {
    switch(repeatMode){
      case RepeatState.off:
        _audioService.setRepeatMode(AudioServiceRepeatMode.one);
        return RepeatState.repeatSong;
      case RepeatState.repeatSong:
        _audioService.setRepeatMode(AudioServiceRepeatMode.all);
        return RepeatState.repeatPlaylist;
      case RepeatState.repeatPlaylist:
        _audioService.setRepeatMode(AudioServiceRepeatMode.none);
      return RepeatState.off;
    }
  }

}