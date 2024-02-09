import 'package:flutter/material.dart';
import 'package:pristine_sound/view/ui_sealed/audio_event.dart';
import 'package:provider/provider.dart';

import '../../view_model/audio_view_model.dart';
import '../play_screen/now_play_track_screen.dart';
import 'audio_bar.dart';
import 'empty_audio_bar.dart';

class AudioBarCheck extends StatelessWidget {
  const AudioBarCheck({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final audioViewModel = context.watch<AudioViewModel>();
    return audioViewModel.state.playList.isNotEmpty
        ? GestureDetector(
            onTap: () {
              final myModel =
                  Provider.of<AudioViewModel>(context, listen: false);
              showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (context) {
                    return ChangeNotifierProvider.value(
                        value: myModel, child: const NowPlayTrackScreen());
                  });
            },
            child: Container(
              color: Colors.white,
              child: AudioBar(
                  audioState: audioViewModel.state,
                  progressBarState: audioViewModel.progressNotifier,
                callback: (event) {
                    switch(event) {
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
            ),
          )
        : const EmptyAudioBar();
  }
}
