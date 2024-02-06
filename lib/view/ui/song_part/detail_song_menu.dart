import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:music_player/domain/model/audio_model.dart';
import 'package:music_player/view/ui/song_part/detail_tile.dart';
import 'package:music_player/view/view_model/audio_view_model.dart';
import 'package:provider/provider.dart';

class DetailSongMenu extends StatelessWidget {
  final AudioModel _song;

  const DetailSongMenu({super.key, required AudioModel song}) : _song = song;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AudioViewModel>();
    return SingleChildScrollView(
      child: SizedBox(
        width: double.maxFinite,
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
              ),
              child: DetailTile(song: _song,),
            ),
            viewModel.state.isShuffleModeEnabled
                ? Container()
                : InkWell(
                    onTap: () {
                      viewModel.addSong(song: _song, isCurrentPlaylistNext: true);
                      context.pop();
                    },
                    child: const SizedBox(
                      width: double.maxFinite,
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                top: 8, right: 16, left: 16, bottom: 8),
                            child: Icon(Icons.playlist_play, size: 32),
                          ),
                          Text(
                            'play next',
                            style: TextStyle(fontSize: 14),
                          )
                        ],
                      ),
                    ),
                  ),
            InkWell(
              onTap: () {
                viewModel.addSong(song: _song);
                context.pop();
              },
              child: const SizedBox(
                width: double.maxFinite,
                child: Row(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.only(top: 8, right: 16, left: 16, bottom: 8),
                      child: Icon(Icons.playlist_add, size: 32),
                    ),
                    Text(
                      'Add to queue',
                      style: TextStyle(fontSize: 14),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}