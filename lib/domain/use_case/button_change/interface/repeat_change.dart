import 'package:audio_service/audio_service.dart';


abstract interface class RepeatChange {
  void execute(AudioServiceRepeatMode repeatMode);
}