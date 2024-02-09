import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'drawer_event.freezed.dart';

@freezed
sealed class DrawerEvent with _$DrawerEvent {
  const factory DrawerEvent.homeChange() = HomeChange;
  const factory DrawerEvent.playListChange() = PlayListChange;
  const factory DrawerEvent.sleepTimerOnTap() = SleepTimerOnTap;
}