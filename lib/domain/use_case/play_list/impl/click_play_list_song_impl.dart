import 'package:music_player/domain/use_case/play_list/interface/click_play_list_song.dart';

import '../../../../data/reposiotry/audio_repository.dart';

class ClickPlayListSongImpl implements ClickPlayListSong {
  final _audioRepository = AudioRepository();

  @override
  void execute({required int idx}) async {
    await _audioRepository.audioPlayer.seek(Duration.zero, index: idx);
  }
}
