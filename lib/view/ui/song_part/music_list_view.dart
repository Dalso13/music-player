import 'package:flutter/material.dart';
import 'package:music_player/view/ui/song_part/detail_song_control.dart';
import 'package:music_player/view/ui/song_part/song_tile.dart';
import 'package:music_player/view/view_model/main_view_model.dart';
import 'package:provider/provider.dart';

class MusicListView extends StatelessWidget {
  const MusicListView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MainViewModel>();
    final state = viewModel.mainState;
    return ListView(
      children: state.songList.map((e) {
        bool isEqual = e.id == state.nowPlaySong.id;
        return GestureDetector(
          onLongPress: () {
            final myModel = Provider.of<MainViewModel>(context, listen: false);
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(30))),
              builder: (context) {
                return DraggableScrollableSheet(
                  expand: false,
                  initialChildSize: 0.3,
                  builder: (context, scrollController) =>
                      ChangeNotifierProvider.value(
                    value: myModel,
                    child: DetailSongControl(song: e),
                  ),
                );
              },
            );
          },
          onTap: () {
            if (isEqual) {
              return;
            }
            viewModel.playMusic(index: state.songList.indexOf(e));
          },
          child: SongTile(song: e, isEqual: isEqual),
        );
      }).toList(),
    );
  }
}
