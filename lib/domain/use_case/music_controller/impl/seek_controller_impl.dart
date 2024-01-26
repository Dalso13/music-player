import 'package:audio_service/audio_service.dart';

import '../../../../data/repository/audio_repository_impl.dart';
import '../interface/seek_controller.dart';

class SeekControllerImpl implements SeekController {
  final AudioHandler _audioService;

  SeekControllerImpl({
    required AudioHandler audioService,
  }) : _audioService = audioService;

  @override
  void execute({required Duration position}) {
    _audioService.seek(position);
  }



}