import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:music_player/core/repeat_state.dart';
import 'package:music_player/view/view_model/main_view_model.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

import '../../../core/button_state.dart';

class NowPlayMusicScreen extends StatelessWidget {
  const NowPlayMusicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MainViewModel>();
    final state = viewModel.mainState;
    final song = state.playList[state.currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('${state.currentIndex}'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 400,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Container(
                      width: 300,
                      height: 300,
                      child: QueryArtworkWidget(
                        keepOldArtwork: true,
                        nullArtworkWidget: Image.network(
                          'https://thumb.silhouette-ac.com/t/96/9629eae865b0d9e1725335c9985216a7_t.jpeg',
                        ),
                        id: state.playList[state.currentIndex].id,
                        type: ArtworkType.AUDIO,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        context.pop();
                      },
                      icon: Icon(Icons.expand_more),
                      iconSize: 40,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ProgressBar(
              progress: viewModel.progressNotifier.current,
              buffered: viewModel.progressNotifier.buffered,
              total: viewModel.progressNotifier.total,
              onSeek: viewModel.seek,
              barHeight: 8,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: Text(
                  song.displayNameWOExt,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                song.artist ?? "No Artist",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: IconButton(
                  onPressed: viewModel.repeatModeChange,
                  icon: switch (state.repeatState) {
                    RepeatState.off => Icon(Icons.repeat, color: Colors.grey),
                    RepeatState.repeatPlaylist => Icon(Icons.repeat),
                    RepeatState.repeatSong => Icon(Icons.repeat_one),
                  },
                ),
              ),
              Row(
                children: [
                  Container(
                    child: IconButton(
                      iconSize: 40,
                      onPressed: viewModel.previousPlay,
                      icon: Icon(Icons.skip_previous),
                    ),
                  ),
                  Container(
                    child: switch (state.buttonState) {
                      ButtonState.paused => IconButton(
                          iconSize: 80,
                          icon: const Icon(Icons.play_circle),
                          onPressed: viewModel.clickPlayButton,
                        ),
                      ButtonState.playing => IconButton(
                          iconSize: 80,
                          icon: const Icon(Icons.pause_circle),
                          onPressed: viewModel.stopMusic,
                        ),
                      ButtonState.loading => Container(
                          margin: EdgeInsets.only(right: 8, left: 8),
                          width: 80.0,
                          height: 80.0,
                          child: const CircularProgressIndicator(),
                        ),
                    },
                  ),
                  Container(
                    child: IconButton(
                      iconSize: 40,
                      onPressed: viewModel.nextPlay,
                      icon: Icon(Icons.skip_next),
                    ),
                  ),
                ],
              ),
              Container(
                child: IconButton(
                    onPressed: viewModel.shuffleModeChange,
                    icon: Icon(
                      Icons.shuffle,
                      color: state.isShuffleModeEnabled
                          ? Colors.black
                          : Colors.grey,
                    )),
              ),
            ],
          ),
          IconButton(
            onPressed: () {
              context.push('/now-play-list');
            },
            icon: Icon(Icons.playlist_add_check),
            iconSize: 40,
          )
        ],
      ),
    );
  }
}
