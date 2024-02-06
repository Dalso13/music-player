import 'package:music_player/domain/use_case/play_list/interface/click_play_list_song.dart';

import '../../../../data/repository/audio_repository_impl.dart';

class ClickPlayListSongImpl implements ClickPlayListSong {
  final _audioRepository = AudioRepositoryImpl();

  @override
  void execute({required int idx}) async {
    int lisIdx = _audioRepository.audioPlayer.effectiveIndices![idx];
    await _audioRepository.audioPlayer.seek(Duration.zero, index: lisIdx);
  }
}
