import 'package:audio_service/audio_service.dart';
import 'package:music_player/data/mapper/audio_model_mapper.dart';
import 'package:music_player/domain/use_case/play_list/interface/play_list_setting.dart';
import '../../../model/audio_model.dart';

// TODO: 리스트에 곡 클릭시
class SetMusicList implements PlayListSetting {
  final AudioHandler _audioService;

  SetMusicList({
    required AudioHandler audioService,
  }) : _audioService = audioService;


  @override
  Future<void> execute({required List<AudioModel> songList}) async {
    await _audioService.addQueueItems(songList.map((e) => e.toMediaItem()).toList());
  }

}