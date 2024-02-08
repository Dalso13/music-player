import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view_model/audio_view_model.dart';
import '../../view_model/state/audio_state.dart';
import '../../view_model/state/progress_bar_state.dart';
import '../play_screen/now_play_track_screen.dart';
import 'audio_bar.dart';
import 'empty_audio_bar.dart';

class AudioBarCheck extends StatelessWidget {
  final void Function() onTap;
  final AudioState audioState;
  final ProgressBarState progressBarState;

  const AudioBarCheck({
    super.key,
    required this.onTap,
    required this.audioState,
    required this.progressBarState,
  });

  @override
  Widget build(BuildContext context) {
    return audioState.playList.isNotEmpty
        ? GestureDetector(
            onTap: () => onTap.call(),
            child: Container(
              color: Colors.white,
              child: AudioBar(
                audioState: audioState,
                progressBarState: progressBarState,
              ),
            ),
          )
        : const EmptyAudioBar();
  }
}
