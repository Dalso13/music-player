import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:music_player/view/view_model/main_view_model.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

import '../../core/button_state.dart';
import 'audio_image.dart';

class AudioBar extends StatelessWidget {
  const AudioBar({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MainViewModel>();
    return Row(
      children: [
        Container(
          height: 60,
            child: AudioImage(
                audioId:
                    viewModel.playList[viewModel.mainState.currentIndex].id)),
        Expanded(
          child: Column(
            children: [
              Container(
                child: ProgressBar(
                  progress: viewModel.progressNotifier.current,
                  buffered: viewModel.progressNotifier.buffered,
                  total: viewModel.progressNotifier.total,
                  onSeek: viewModel.seek,
                ),
              ),
              Row(
                children: [
                  Container(
                    child: IconButton(
                      onPressed: viewModel.previousPlay,
                      icon: Icon(Icons.skip_previous),
                    ),
                  ),
                  Container(
                      child: switch (viewModel.mainState.buttonState) {
                    ButtonState.paused => IconButton(
                        icon: const Icon(Icons.play_arrow),
                        onPressed: viewModel.clickPlayButton,
                      ),
                    ButtonState.playing => IconButton(
                        icon: const Icon(Icons.pause),
                        onPressed: viewModel.stopMusic,
                      ),
                    ButtonState.loading => Container(
                        margin: EdgeInsets.only(right: 8, left: 8),
                        width: 16.0,
                        height: 16.0,
                        child: const CircularProgressIndicator(),
                      ),
                  }),
                  Container(
                    child: IconButton(
                      onPressed: viewModel.nextPlay,
                      icon: Icon(Icons.skip_next),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
