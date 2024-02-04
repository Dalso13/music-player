import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view_model/audio_view_model.dart';
import '../play_screen/now_play_track_screen.dart';
import 'audio_bar.dart';
import 'empty_audio_bar.dart';

class AudioBarCheck extends StatelessWidget {
  final bool _isBool;

  const AudioBarCheck({
    super.key,
    required bool isBool,
  }) : _isBool = isBool;

  @override
  Widget build(BuildContext context) {
    return _isBool ? GestureDetector(
      onTap: () {
        final myModel =
        Provider.of<AudioViewModel>(context, listen: false);
        showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) {
              return ChangeNotifierProvider.value(
                  value: myModel,
                  child: const NowPlayTrackScreen());
            });
      },
      child:
      Container(color: Colors.white, child: const AudioBar()),
    )
    : const EmptyAudioBar();
  }



}
