import 'package:just_audio/just_audio.dart';
import '../../../../core/button_state.dart';

abstract interface class AudioPlayerStateStream {
  ButtonState execute(PlayerState playerState);
}