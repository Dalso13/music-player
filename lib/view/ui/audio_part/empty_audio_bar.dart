import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';

class EmptyAudioBar extends StatelessWidget {
  const EmptyAudioBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
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
                  color: Colors.grey.withOpacity(0.5),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 8),
                  width: 150,
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '재생 목록 비어있음',
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              child: Row(
                children: [
                  Container(
                      child: Icon(Icons.skip_previous)
                  ),
                  Container(
                      child: const Icon(Icons.play_arrow)
                  ),
                  Container(
                      child: Icon(Icons.skip_next)
                  ),
                ],
              ),
            ),
          ],
        ),
        Container(
          child: const ProgressBar(
            progress: Duration.zero,
            buffered: null,
            total: Duration.zero,
            onSeek: null,
            timeLabelLocation: TimeLabelLocation.none,
            barHeight: 3,
          ),
        ),
      ],
    );
  }
}
