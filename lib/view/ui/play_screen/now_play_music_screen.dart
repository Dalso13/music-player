import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:music_player/core/repeat_state.dart';
import 'package:music_player/view/ui/play_screen/now_play_list_screen.dart';
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
    final song = state.nowPlaySong;

    return Scaffold(
      backgroundColor: Color(state.artColor).withOpacity(0.6),
      body: Container(
        child: Column(
          children: [
              Container(
                height: 500,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            context.pop();
                          },
                          icon: Icon(Icons.expand_more),
                          iconSize: 40,
                        ),
                      ],
                    ),
                    ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                      child: Container(
                        width: 300,
                        height: 300,
                        child: QueryArtworkWidget(
                          keepOldArtwork: true,
                          nullArtworkWidget: Image.asset(
                            'assets/images/art_image.jpeg',
                          ),
                          id: song.id,
                          type: ArtworkType.AUDIO,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ProgressBar(
                timeLabelPadding: 8,
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
                  song.artist,
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
          ],
        ),
      ),
      bottomNavigationBar: Container(
        width: double.maxFinite,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
         color: Color(state.artColor),
        ),
        child: InkWell(
          onTap: () {
            final myModel = Provider.of<MainViewModel>(context, listen: false);
            showMaterialModalBottomSheet(
                context: context,
                builder: (context) {
                  return ChangeNotifierProvider.value(
                      value: myModel, child: const NowPlayListScreen());
                });
          },
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Icon(Icons.playlist_add, color: Colors.black),
                Text('List'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
