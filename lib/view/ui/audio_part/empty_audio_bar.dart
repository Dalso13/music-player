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
                  width: 180,
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '재생중인 목록이 없습니다.',
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                IconButton(onPressed: (){}, icon: const Icon(Icons.skip_previous)),
                IconButton(onPressed: (){}, icon: const Icon(Icons.play_arrow)),
                IconButton(onPressed: (){}, icon: const Icon(Icons.skip_next)),
              ],
            ),
          ],
        ),
        const ProgressBar(
          progress: Duration.zero,
          buffered: null,
          total: Duration.zero,
          onSeek: null,
          timeLabelLocation: TimeLabelLocation.none,
          barHeight: 3,
        ),
      ],
    );
  }
}
