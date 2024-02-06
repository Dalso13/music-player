import '../../../../data/repository/audio_repository_impl.dart';
import '../interface/get_current_index.dart';

class GetCurrentIndexImpl implements GetCurrentIndex {
  final _audioRepository = AudioRepositoryImpl();

  @override
  int execute({required int index}) {
    if (_audioRepository.audioPlayer.shuffleModeEnabled == false) return index;
    return _audioRepository.audioPlayer.effectiveIndices!.indexOf(index);

  }

}