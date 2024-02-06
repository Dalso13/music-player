import 'package:audio_service/audio_service.dart';
import '../interface/sleep_timer_pause.dart';

class SleepTimerPauseImpl implements SleepTimerPause {
  final AudioHandler _audioService;

  SleepTimerPauseImpl({
    required AudioHandler audioService,
  }) : _audioService = audioService;

  @override
  void execute() {
    _audioService.customAction('sleepTimerPause');
  }


}
