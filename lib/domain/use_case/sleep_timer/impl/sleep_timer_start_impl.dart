import 'package:audio_service/audio_service.dart';
import '../interface/sleep_timer_start.dart';

class SleepTimerStartImpl implements SleepTimerStart {
  final AudioHandler _audioService;

  SleepTimerStartImpl({
    required AudioHandler audioService,
  }) : _audioService = audioService;

  @override
  void execute({required int minutes}) {
    // map : time
    _audioService.customAction('sleepTimerStart',{'time' : minutes});
  }


}
