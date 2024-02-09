import 'package:hive/hive.dart';

import 'audio_model.dart';

part 'custom_play_list_model.g.dart';

@HiveType(typeId: 0)
class CustomPlayListModel {
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

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'playList': playList,
      'modelKey': modelKey,
    };
  }

  factory CustomPlayListModel.fromJson(Map<String, dynamic> map) {
    return CustomPlayListModel(
      title: map['title'] as String,
      playList: map['playList'] as List<AudioModel>,
      modelKey: map['modelKey'] as int,
    );
  }
}