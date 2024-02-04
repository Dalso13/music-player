import 'package:hive/hive.dart';
import 'package:music_player/domain/model/audio_model.dart';

part 'custom_play_list_model.g.dart';

@HiveType(typeId: 0)
class CustomPlayListModel{
  @HiveField(0)
  String title;

  @HiveField(1)
  List<AudioModel> playList;

  @HiveField(2)
  int? modelKey;

  CustomPlayListModel({
    required this.title,
    required this.playList,
    this.modelKey,
  });
}