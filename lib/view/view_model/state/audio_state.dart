import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../core/button_state.dart';
import '../../../core/repeat_state.dart';
import '../../../domain/model/audio_model.dart';

part 'audio_state.freezed.dart';

part 'audio_state.g.dart';

@freezed
class AudioState with _$AudioState {
  const factory AudioState({
    @Default(false) bool isLoading,
    @Default(false) bool isShuffleModeEnabled,
    @Default(0xff000000)  int artColor,
    @Default([]) List<int> shuffleIndices,
    @Default(-1) int currentIndex,
    @Default(ButtonState.paused) ButtonState buttonState,
    @Default(RepeatState.off) RepeatState repeatState,
    @Default([]) List<AudioModel> songList,
    @Default([]) List<AudioModel> playList,
    @Default(AudioModel()) AudioModel nowPlaySong,
  }) = _AudioState;

  factory AudioState.fromJson(Map<String, Object?> json) => _$AudioStateFromJson(json);
}