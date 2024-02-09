import 'package:audio_service/audio_service.dart';
import 'package:pristine_sound/data/mapper/audio_model_mapper.dart';
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

    final data = songList.map((e) => e.toMediaItem()).toList();
    await _audioService.addQueueItems(data);
    if (index != null) {
      await _audioService.skipToQueueItem(index);
    } else {
      await _audioService.skipToQueueItem(0);
    }
  }

}