import '../../../../data/repository/audio_repository_impl.dart';
import '../interface/click_play_list_song.dart';

class ClickPlayListSongImpl implements ClickPlayListSong {
  final _audioRepository = AudioRepositoryImpl();

  @override
  void execute({required int idx}) async {
    int lisIdx = _audioRepository.audioPlayer.effectiveIndices![idx];
    await _audioRepository.audioPlayer.seek(Duration.zero, index: lisIdx);
  }
}
