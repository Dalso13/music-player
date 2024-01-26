import 'package:audio_service/audio_service.dart';

import '../interface/dispose_controller.dart';

class DisposeControllerImpl implements DisposeController{
  final AudioHandler _audioService;

  DisposeControllerImpl({
    required AudioHandler audioService,
  }) : _audioService = audioService;

  @override
  void execute() {
    _audioService.customAction('dispose');
  }

}