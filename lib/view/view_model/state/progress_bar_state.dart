// class ProgressBarState {
//   ProgressBarState({
//     required this.current,
//     required this.buffered,
//     required this.total,
//   });
//   final Duration current;
//   final Duration buffered;
//   final Duration total;
// }

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'progress_bar_state.freezed.dart';

part 'progress_bar_state.g.dart';

@freezed
class ProgressBarState with _$ProgressBarState {
  const factory ProgressBarState({
    @Default(Duration.zero) Duration current,
    @Default(Duration.zero) Duration buffered,
    @Default(Duration.zero) Duration total,
  }) = _ProgressBarState;

  factory ProgressBarState.fromJson(Map<String, Object?> json) => _$ProgressBarStateFromJson(json);
}