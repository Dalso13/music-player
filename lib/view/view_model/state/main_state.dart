import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:music_player/core/screen_change_state.dart';

part 'main_state.freezed.dart';

part 'main_state.g.dart';

@freezed
class MainState with _$MainState {
  const factory MainState({
    @Default(ScreenChangeState.home) ScreenChangeState screenChangeState,
    @Default(false) bool isPermission,
    @Default(false) bool isPermissionLoading,
    @Default(0) int clickPlayListIndex,
  }) = _MainState;

  factory MainState.fromJson(Map<String, Object?> json) => _$MainStateFromJson(json);
}