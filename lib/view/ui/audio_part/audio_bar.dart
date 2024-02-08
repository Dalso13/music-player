import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:pristine_sound/view/ui/audio_part/audio_event.dart';

import '../../../core/button_state.dart';
import '../../view_model/state/audio_state.dart';
import '../../view_model/state/progress_bar_state.dart';
import 'audio_image.dart';

class AudioBar extends StatelessWidget {
  final void Function(AudioEvent event)? callback;
  final AudioState audioState;
  final ProgressBarState progressBarState;

  const AudioBar({
    super.key,
    this.callback,
    required this.audioState,
    required this.progressBarState,
  });

  @override
  Widget build(BuildContext context) {
    final isSize = MediaQuery.of(context).size.width < 360;
    final song = audioState.nowPlaySong;
    return Row(
      children: [
        Expanded(
            child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 8, left: 8, top: 8),
                      width: 60,
                      height: 60,
                      child: Hero(
                        tag: song.id,
                        child: AudioImage(audioId: song.id),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 8),
                      width: 150,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            song.displayNameWOExt,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                            maxLines: 1,
                          ),
                          Text(
                            song.artist,
                            style: const TextStyle(color: Colors.grey),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    isSize
                        ? Container()
                        : IconButton(
                            onPressed: () => callback?.call(const AudioEvent.previousPlay()),
                            icon: const Icon(Icons.skip_previous),
                          ),
                    Container(
                        child: switch (audioState.buttonState) {
                      ButtonState.paused => IconButton(
                          icon: const Icon(Icons.play_arrow),
                          onPressed: () => callback?.call(const AudioEvent.clickPlayButton()),
                        ),
                      ButtonState.playing => IconButton(
                          icon: const Icon(Icons.pause),
                          onPressed: () => callback?.call(const AudioEvent.stopMusic()),
                        ),
                      ButtonState.loading => Container(
                          margin: const EdgeInsets.only(right: 8, left: 8),
                          width: 16.0,
                          height: 16.0,
                          child: const CircularProgressIndicator(),
                        ),
                    }),
                    IconButton(
                      onPressed: () => callback?.call(const AudioEvent.nextPlay()),
                      icon: const Icon(Icons.skip_next),
                    ),
                  ],
                ),
              ],
            ),
            ProgressBar(
              progress: progressBarState.current,
              buffered: progressBarState.buffered,
              total: progressBarState.total,
              onSeek: (duration) => callback?.call(AudioEvent.seek(duration)),
              timeLabelLocation: TimeLabelLocation.none,
              barHeight: 3,
            ),
          ],
        )),
      ],
    );
  }
}
