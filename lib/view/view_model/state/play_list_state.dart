import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

import '../../../domain/model/audio_model.dart';
import '../../../domain/model/custom_play_list_model.dart';

part 'play_list_state.freezed.dart';

part 'play_list_state.g.dart';

@freezed
class PlayListState with _$PlayListState {
  const factory PlayListState({
    @Default([])List<CustomPlayListModel> customPlayList,
    @Default([])List<AudioModel> selectList,
  }) = _PlayListState;

  factory PlayListState.fromJson(Map<String, Object?> json) => _$PlayListStateFromJson(json);
}