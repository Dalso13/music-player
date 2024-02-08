import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'audio_event.freezed.dart';

@freezed
sealed class AudioEvent with _$AudioEvent {
  const factory AudioEvent.previousPlay() = PreviousPlay;
  const factory AudioEvent.clickPlayButton() = ClickPlayButton;
  const factory AudioEvent.seek(Duration duration) = Seek;
  const factory AudioEvent.nextPlay() = NextPlay;
  const factory AudioEvent.stopMusic() = StopMusic;
}


