import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'audio_model.freezed.dart';

part 'audio_model.g.dart';

@freezed
class AudioModel with _$AudioModel {
  const factory AudioModel({
    required String displayNameWOExt,
    required String artist,
    required int duration,
    required int id,
    required String data,
  }) = _AudioModel;

  factory AudioModel.fromJson(Map<String, Object?> json) => _$AudioModelFromJson(json);
}