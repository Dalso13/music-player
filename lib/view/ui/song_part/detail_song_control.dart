import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:music_player/domain/model/audio_model.dart';
import 'package:music_player/view/ui/song_part/detail_tile.dart';
import 'package:music_player/view/view_model/audio_view_model.dart';
import 'package:provider/provider.dart';

class DetailSongControl extends StatelessWidget {
  final AudioModel _song;

  const DetailSongControl({super.key, required AudioModel song}) : _song = song;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AudioViewModel>();
    return Container(
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
          viewModel.mainState.isShuffleModeEnabled
              ? Container()
              : InkWell(
                  onTap: () {
                    viewModel.addSong(song: _song, isCurrentPlaylistNext: true);
                    context.pop();
                  },
                  child: Container(
                    width: double.maxFinite,
                    child: const Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              top: 8, right: 16, left: 16, bottom: 8),
                          child: Icon(Icons.playlist_play, size: 32),
                        ),
                        Text(
                          '다음 곡으로 재생',
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
            child: Container(
              width: double.maxFinite,
              child: const Row(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(top: 8, right: 16, left: 16, bottom: 8),
                    child: Icon(Icons.playlist_add, size: 32),
                  ),
                  Text(
                    '현재 재생목록에 추가',
                    style: TextStyle(fontSize: 14),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
