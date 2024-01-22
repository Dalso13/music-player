import 'package:just_audio/just_audio.dart';
import 'package:music_player/domain/use_case/play_list/interface/play_list_setting.dart';
import 'package:music_player/domain/use_case/play_list/interface/shuffle_play_list_setting.dart';
import 'package:on_audio_query_platform_interface/src/models/song_model.dart';
import '../../../../data/reposiotry/audio_repository.dart';


// TODO: 메인 화면 서플 버튼 누를시
class ShuffleMusicList implements ShufflePlayListSetting {
  final _audioRepository = AudioRepository();

  @override
  Future<List<SongModel>> execute({required List<SongModel> songList}) async {
    final audioPlayer = _audioRepository.audioPlayer;
    final List<SongModel> shuffleSongList = songList.toList();
    shuffleSongList.shuffle();

    final playlist = ConcatenatingAudioSource(
        children: shuffleSongList.map((e) {
          return AudioSource.file(e.getMap['_data']);
        }).toList()
    );
    await audioPlayer.setAudioSource(playlist,initialPosition: Duration.zero);

    return shuffleSongList;
  }
}