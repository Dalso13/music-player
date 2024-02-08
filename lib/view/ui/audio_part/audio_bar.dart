import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/button_state.dart';
import '../../view_model/audio_view_model.dart';
import 'audio_image.dart';

class AudioBar extends StatelessWidget {
  const AudioBar({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AudioViewModel>();
    final song = viewModel.state.nowPlaySong;
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
                        margin: const EdgeInsets.only(right: 8, left: 8,top: 8),
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
                      IconButton(
                        onPressed: viewModel.previousPlay,
                        icon: const Icon(Icons.skip_previous),
                      ),
                      Container(
                          child: switch (viewModel.state.buttonState) {
                        ButtonState.paused => IconButton(
                            icon: const Icon(Icons.play_arrow),
                            onPressed: viewModel.clickPlayButton,
                          ),
                        ButtonState.playing => IconButton(
                            icon: const Icon(Icons.pause),
                            onPressed: viewModel.stopMusic,
                          ),
                        ButtonState.loading => Container(
                            margin: const EdgeInsets.only(right: 8, left: 8),
                            width: 16.0,
                            height: 16.0,
                            child: const CircularProgressIndicator(),
                          ),
                      }),
                      IconButton(
                        onPressed: viewModel.nextPlay,
                        icon: const Icon(Icons.skip_next),
                      ),
                    ],
                  ),
                ],
              ),
              ProgressBar(
                progress: viewModel.progressNotifier.current,
                buffered: viewModel.progressNotifier.buffered,
                total: viewModel.progressNotifier.total,
                onSeek: viewModel.seek,
                timeLabelLocation: TimeLabelLocation.none,
                barHeight: 3,
              ),
            ],
          )
        ),
      ],
    );
  }
}
