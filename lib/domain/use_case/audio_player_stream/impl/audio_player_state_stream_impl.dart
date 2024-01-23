import 'package:just_audio/just_audio.dart';
import '../../../../core/button_state.dart';
import '../../../../data/reposiotry/audio_repository.dart';
import '../interface/audio_player_state_stream.dart';

class AudioPlayerStateStreamImpl implements AudioPlayerStateStream {
  final _audioRepository = AudioRepository();

  @override
  ButtonState execute(PlayerState playerState) {
    final isPlaying = playerState.playing;
    final processingState = playerState.processingState;
    if (processingState == ProcessingState.loading ||
        processingState == ProcessingState.buffering) {
      return ButtonState.playing;
    } else if (!isPlaying) {
      return ButtonState.paused;
    } else if (processingState != ProcessingState.completed) {
      return ButtonState.playing;
    } else {
      _audioRepository.audioPlayer.seek(Duration.zero);
      _audioRepository.audioPlayer.pause();
      return ButtonState.paused;
    }
  }

}