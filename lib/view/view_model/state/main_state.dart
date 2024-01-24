import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import '../../../core/button_state.dart';
import '../../../core/repeat_state.dart';
import '../../../domain/model/audio_model.dart';

part 'main_state.freezed.dart';

part 'main_state.g.dart';

@freezed
class MainState with _$MainState {
  const factory MainState({
    @Default(false) bool isLoading,
    @Default(false) bool isShuffleModeEnabled,
    @Default([]) List<int> shuffleIndices,
    @Default(0) int currentIndex,
    @Default(ButtonState.paused) ButtonState buttonState,
    @Default(RepeatState.off) RepeatState repeatState,
    @Default([]) List<AudioModel> songList,
    @Default([]) List<AudioModel> playList,
  }) = _MainState;

  factory MainState.fromJson(Map<String, Object?> json) => _$MainStateFromJson(json);
}