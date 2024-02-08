import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pristine_sound/data/mapper/audio_model_mapper.dart';
import '../../../../data/repository/audio_repository_impl.dart';
import '../../../model/audio_model.dart';
import '../interface/play_list_setting.dart';

// TODO: 리스트에 곡 클릭시
class SetMusicList implements PlayListSetting {
  final AudioHandler _audioService;

  SetMusicList({
    required AudioHandler audioService,
  }) : _audioService = audioService;


  @override
  Future<void> execute({required List<AudioModel> songList , int? index}) async {

    await _audioService.addQueueItems(songList.map((e) => e.toMediaItem()).toList());
    if(index == null || index <= 0) return;
    await _audioService.skipToQueueItem(index);
  }

}