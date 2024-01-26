import 'package:audio_service/audio_service.dart';
import '../../../../core/button_state.dart';

abstract interface class AudioPlayerStateStream {
  ButtonState execute({required PlaybackState playbackState});
}