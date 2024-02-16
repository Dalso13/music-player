import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pristine_sound/view/ui_sealed/audio_event.dart';
import 'package:provider/provider.dart';

import '../../view_model/audio_view_model.dart';
import '../play_screen/now_play_track_screen.dart';
import 'audio_bar.dart';
import 'empty_audio_bar.dart';

class AudioBarCheck extends StatelessWidget {
  final bool _isTrackList;

  const AudioBarCheck({
    super.key,
    bool isTrackList = false,
  }) : _isTrackList = isTrackList;

  @override
  Widget build(BuildContext context) {
    final audioViewModel = context.watch<AudioViewModel>();
    return audioViewModel.state.playList.isNotEmpty
        ? GestureDetector(
            onTap: () {
              if(_isTrackList) {
                context.pop();
              } else {
                showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (context) {
                    return ChangeNotifierProvider.value(
                        value: audioViewModel, child: const NowPlayTrackScreen());
                  },
                );
              }


            },
            child: AudioBar(
              audioState: audioViewModel.state,
              progressBarState: audioViewModel.progressNotifier,
              onEvent: (event) {
                switch (event) {
                  case PreviousPlay():
                    audioViewModel.previousPlay();
                    break;
                  case ClickPlayButton():
                    audioViewModel.clickPlayButton();
                    break;
                  case Seek():
                    audioViewModel.seek(event.duration);
                    break;
                  case NextPlay():
                    audioViewModel.nextPlay();
                    break;
                  case StopMusic():
                    audioViewModel.stopMusic();
                    break;
                }
              },
            ),
          )
        : const EmptyAudioBar();
  }
}
