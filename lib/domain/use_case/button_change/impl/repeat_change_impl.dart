import 'package:just_audio/just_audio.dart';
import 'package:music_player/core/repeat_state.dart';
import 'package:music_player/data/reposiotry/audio_repository.dart';
import '../interface/repeat_change.dart';

class RepeatChangeImpl implements RepeatChange{
  final AudioRepository _audioRepository = AudioRepository();

  RepeatState execute(RepeatState repeatState) {
    switch(repeatState){
      case RepeatState.off:
        _audioRepository.audioPlayer.setLoopMode(LoopMode.all);
        return RepeatState.repeatPlaylist;
      case RepeatState.repeatPlaylist:
        _audioRepository.audioPlayer.setLoopMode(LoopMode.one);
        return RepeatState.repeatSong;
      case RepeatState.repeatSong:
        _audioRepository.audioPlayer.setLoopMode(LoopMode.off);
        return RepeatState.off;
    }
  }

}