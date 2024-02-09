import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

part 'audio_model.freezed.dart';

part 'audio_model.g.dart';

@HiveType(typeId: 5)
@freezed
class AudioModel with _$AudioModel {
  const factory AudioModel({
    @HiveField(0) @Default('No title') String displayNameWOExt,
    @HiveField(1) @Default('No artist') String artist,
    @HiveField(2) @Default(0) int duration,
    @HiveField(3) @Default(-1) int id,
    @HiveField(4) @Default('') String data,
  }) = _AudioModel;


  factory AudioModel.fromJson(Map<String, Object?> json) => _$AudioModelFromJson(json);
}