import 'package:just_audio/just_audio.dart';
import 'package:music_player/domain/use_case/play_list/interface/play_list_setting.dart';
import '../../../../data/reposiotry/audio_repository.dart';
import '../../../model/audio_model.dart';

// TODO: 리스트에 곡 클릭시
class SetMusicList implements PlayListSetting {
  final _audioRepository = AudioRepository();

  @override
  Future<List<AudioModel>> execute({required int index, required List<AudioModel> songList}) async {
    final audioPlayer = _audioRepository.audioPlayer;

    final playlist = ConcatenatingAudioSource(
        children:songList.getRange(index, songList.length).map((e) {
          return AudioSource.file(e.data);
        }).toList()
    );
    await audioPlayer.setAudioSource(playlist,initialPosition: Duration.zero);

    return songList.getRange(index, songList.length).toList();
  }
}