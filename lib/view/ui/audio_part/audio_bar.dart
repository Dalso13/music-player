import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';

import '../../../core/button_state.dart';
import '../../ui_sealed/audio_event.dart';
import '../../view_model/state/audio_state.dart';
import '../../view_model/state/progress_bar_state.dart';
import 'audio_image.dart';

class AudioBar extends StatelessWidget {
  final void Function(AudioEvent event) _onEvent;
  final AudioState _audioState;
  final ProgressBarState _progressBarState;


  const AudioBar({
    super.key,
    required void Function(AudioEvent event) onEvent,
    required AudioState audioState,
    required ProgressBarState progressBarState,
  })  : _onEvent = onEvent,
        _audioState = audioState,
        _progressBarState = progressBarState;

  @override
  Widget build(BuildContext context) {
    final isSize = MediaQuery.of(context).size.width < 360;
    final song = _audioState.nowPlaySong;
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
                          onPressed: () => _onEvent(const AudioEvent.previousPlay()),
                          icon: const Icon(Icons.skip_previous),
                        ),
                        Container(
                            child: switch (_audioState.buttonState) {
                              ButtonState.paused => IconButton(
                                icon: const Icon(Icons.play_arrow),
                                onPressed: () => _onEvent(const AudioEvent.clickPlayButton()),
                              ),
                              ButtonState.playing => IconButton(
                                icon: const Icon(Icons.pause),
                                onPressed: () => _onEvent(const AudioEvent.stopMusic()),
                              ),
                              ButtonState.loading => Container(
                                margin: const EdgeInsets.only(right: 8, left: 8),
                                width: 16.0,
                                height: 16.0,
                                child: const CircularProgressIndicator(),
                              ),
                            }),
                        IconButton(
                          onPressed: () => _onEvent(const AudioEvent.nextPlay()),
                          icon: const Icon(Icons.skip_next),
                        ),
                      ],
                    ),
                  ],
                ),
                ProgressBar(
                  progress: _progressBarState.current,
                  buffered: _progressBarState.buffered,
                  total: _progressBarState.total,
                  onSeek: (duration) => _onEvent(AudioEvent.seek(duration)),
                  timeLabelLocation: TimeLabelLocation.none,
                  barHeight: 3,
                ),
              ],
            )),
      ],
    );
  }
}