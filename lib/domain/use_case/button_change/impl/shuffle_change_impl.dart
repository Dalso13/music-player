import 'package:audio_service/audio_service.dart';
import 'package:music_player/domain/use_case/button_change/interface/shuffle_change.dart';

class ShuffleChangeImpl implements ShuffleChange{
  final AudioHandler _audioService;

  ShuffleChangeImpl({
    required AudioHandler audioService,
  }) : _audioService = audioService;


  @override
  Future<bool> execute({required bool isShuffleModeEnabled}) async {

    final enable = !isShuffleModeEnabled;
    // TODO : 뭔가 작동이 이상하게 되서 보류
    // if (enable) {
    //   await _audioService.setShuffleMode(AudioServiceShuffleMode.all);
    // } else {
    //   await _audioService.setShuffleMode(AudioServiceShuffleMode.none);
    // }
    return enable;

  }

}