import 'package:music_player/data/reposiotry/audio_repository.dart';
import 'package:music_player/domain/use_case/button_change/interface/shuffle_change.dart';

class ShuffleChangeImpl implements ShuffleChange{
  final AudioRepository _audioRepository = AudioRepository();

  @override
  Future<void> execute({required bool isShuffleModeEnabled}) async {
    await _audioRepository.audioPlayer.setShuffleModeEnabled(!isShuffleModeEnabled);
    if (isShuffleModeEnabled) {
      await _audioRepository.audioPlayer.shuffle();
    }
  }

}