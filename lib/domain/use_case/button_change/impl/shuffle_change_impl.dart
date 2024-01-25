import 'package:audio_service/audio_service.dart';
import 'package:music_player/data/repository/audio_repository_impl.dart';
import 'package:music_player/domain/use_case/button_change/interface/shuffle_change.dart';

class ShuffleChangeImpl implements ShuffleChange{
  final AudioRepositoryImpl _audioRepository = AudioRepositoryImpl();

  @override
  Future<void> execute({required AudioServiceShuffleMode shuffleMode}) async {
    if (shuffleMode == AudioServiceShuffleMode.none) {
      _audioRepository.audioPlayer.setShuffleModeEnabled(false);
    } else {
      await  _audioRepository.audioPlayer.shuffle();
      _audioRepository.audioPlayer.setShuffleModeEnabled(true);
    }

  }

}