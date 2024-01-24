import 'package:music_player/data/repository/audio_repository_impl.dart';
import 'package:music_player/domain/use_case/button_change/interface/shuffle_change.dart';

class ShuffleChangeImpl implements ShuffleChange{
  final AudioRepositoryImpl _audioRepository = AudioRepositoryImpl();

  @override
  Future<void> execute({required bool isShuffleModeEnabled}) async {
    await _audioRepository.audioPlayer.setShuffleModeEnabled(!isShuffleModeEnabled);
    if (isShuffleModeEnabled) {
      await _audioRepository.audioPlayer.shuffle();
    }
  }

}