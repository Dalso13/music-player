import 'dart:ui';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:music_player/core/repeat_state.dart';
import 'package:music_player/view/ui/play_screen/now_play_track_list_screen.dart';
import 'package:music_player/view/view_model/audio_view_model.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

import '../../../core/button_state.dart';

class NowPlayTrackScreen extends StatelessWidget {
  const NowPlayTrackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AudioViewModel>();
    final state = viewModel.state;
    final song = state.nowPlaySong;

    return Scaffold(
      backgroundColor: Colors.black38,
      body: Stack(
        children: [
          Container(
            width: double.maxFinite,
            height: double.maxFinite,
            color: Colors.black.withOpacity(0.85),
            child: Opacity(
              opacity: 0.2,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
                child: QueryArtworkWidget(
                  artworkQuality: FilterQuality.high,
                  keepOldArtwork: true,
                  nullArtworkWidget: Image.asset(
                    'assets/images/art_image.png',
                  ),
                  id: song.id,
                  type: ArtworkType.AUDIO,
                  artworkFit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 400,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              context.pop();
                            },
                            icon: const Icon(Icons.expand_more,color: Colors.white,),
                            iconSize: 40,
                          ),
                        ],
                      ),
                      ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8.0)),
                        child: Container(
                          width: 250,
                          height: 250,
                          child: QueryArtworkWidget(
                            artworkQuality: FilterQuality.high,
                            artworkFit: BoxFit.fitWidth,
                            keepOldArtwork: true,
                            nullArtworkWidget: Image.asset(
                              'assets/images/art_image.png',
                            ),
                            id: song.id,
                            type: ArtworkType.AUDIO,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                      child: Container(
                        margin: const EdgeInsets.only(left: 16, right: 16),
                        child: Text(
                          song.displayNameWOExt,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 26, color: Colors.white),
                        ),
                      ),
                    ),
                    Text(
                      song.artist,
                      style: const TextStyle(color: Colors.blueGrey, fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 16, right: 16),
                  child: ProgressBar(
                    timeLabelPadding: 8,
                    progress: viewModel.progressNotifier.current,
                    buffered: viewModel.progressNotifier.buffered,
                    total: viewModel.progressNotifier.total,
                    onSeek: viewModel.seek,
                    barHeight: 8,
                    timeLabelTextStyle: const TextStyle(color: Colors.white),
                    baseBarColor: Colors.white10,
                    bufferedBarColor: Colors.white10,
                    thumbColor: Colors.white,
                    progressBarColor: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      padding: const EdgeInsets.only(left: 16),
                      onPressed: viewModel.repeatModeChange,
                      icon: switch (state.repeatState) {
                        RepeatState.off =>
                          const Icon(Icons.repeat, color: Colors.white54),
                        RepeatState.repeatPlaylist => const Icon(Icons.repeat,color: Colors.white),
                        RepeatState.repeatSong => const Icon(Icons.repeat_one, color: Colors.white),
                      },
                    ),
                    Row(
                      children: [
                        IconButton(
                          iconSize: 40,
                          onPressed: viewModel.previousPlay,
                          icon: const Icon(Icons.skip_previous, color: Colors.white),
                        ),
                        Container(
                          child: switch (state.buttonState) {
                            ButtonState.paused => AnimatedContainer(
                              duration: const Duration(milliseconds: 100),
                              child: IconButton(
                                  iconSize: 80,
                                  icon: const Icon(Icons.play_circle),
                                  onPressed: viewModel.clickPlayButton,
                                  color: Color(viewModel.state.artColor),
                                ),
                            ),
                            ButtonState.playing => AnimatedContainer(
                              duration: const Duration(milliseconds: 100),
                              child: IconButton(
                                  iconSize: 80,
                                  icon: const Icon(Icons.pause_circle),
                                  onPressed: viewModel.stopMusic,
                                  color: Color(viewModel.state.artColor),
                                ),
                            ),
                            ButtonState.loading => Container(
                                margin: const EdgeInsets.only(right: 8, left: 8),
                                width: 80.0,
                                height: 80.0,
                                child: const CircularProgressIndicator(),
                                color: Color(viewModel.state.artColor),
                              ),
                          },
                        ),
                        IconButton(
                          iconSize: 40,
                          onPressed: viewModel.nextPlay,
                          icon: const Icon(Icons.skip_next, color: Colors.white),
                        ),
                      ],
                    ),
                    IconButton(
                      padding: const EdgeInsets.only(right: 16),
                      onPressed: viewModel.shuffleModeChange,
                      icon: Icon(
                        Icons.shuffle,
                        color: state.isShuffleModeEnabled
                            ? Colors.white
                            : Colors.white54,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    final myModel =
                        Provider.of<AudioViewModel>(context, listen: false);
                    showMaterialModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return ChangeNotifierProvider.value(
                              value: myModel,
                              child: const NowPlayTrackListScreen());
                        });
                  },
                  icon: const Icon(
                    Icons.playlist_play,
                    size: 36,
                    color: Colors.black,
                  ),
                  label: const Text('next track', style: TextStyle(color: Colors.black)),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
