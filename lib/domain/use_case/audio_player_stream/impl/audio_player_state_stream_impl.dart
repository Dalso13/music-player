import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import '../../../../core/button_state.dart';
import '../../../../data/repository/audio_repository_impl.dart';
import '../interface/audio_player_state_stream.dart';

class AudioPlayerStateStreamImpl implements AudioPlayerStateStream {
  final _audioRepository = AudioRepositoryImpl();

  @override
  ButtonState execute({required PlaybackState playbackState}) {
    final isPlaying = playbackState.playing;
    final processingState = playbackState.processingState;
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