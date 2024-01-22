import 'package:flutter/material.dart';
import 'package:music_player/view/view_model/main_view_model.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class MusicListView extends StatelessWidget {
  const MusicListView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MainViewModel>();
    return ListView(
      children: viewModel.songList.map((e) {
        return ListTile(
          onTap: () {
            viewModel.playMusic(index: viewModel.songList.indexOf(e));
          },
          title: Text(e.displayNameWOExt,
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          subtitle: Text(e.artist ?? "No Artist"),
          // e.getMap['_data'] 파일 위치 얻기
          trailing: Text('${e.duration ?? 0}',
              style: TextStyle(color: Colors.grey)),
          // This Widget will query/load image.
          // You can use/create your own widget/method using [queryArtwork].
          leading: QueryArtworkWidget(
            controller: viewModel.audioQuery,
            id: e.id,
            type: ArtworkType.AUDIO,
          ),
        );
      }).toList(),
    );
  }
}
