import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'audio_model.freezed.dart';

part 'audio_model.g.dart';

@freezed
class AudioModel with _$AudioModel {
  const factory AudioModel({
    @Default('No title') String displayNameWOExt,
    @Default('No artist') String artist,
    @Default(0) int duration,
    @Default(-1) int id,
    @Default('') String data,
  }) = _AudioModel;


  factory AudioModel.fromJson(Map<String, Object?> json) => _$AudioModelFromJson(json);
}