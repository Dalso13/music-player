import 'package:flutter/material.dart';
import 'package:music_player/view/view_model/main_view_model.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool _hasPermission = false;

  @override
  void initState() {
    super.initState();
    // Check and request for permission.
    Future.microtask(() {
      checkAndRequestPermissions(context.read<MainViewModel>().audioQuery);
      context.read<MainViewModel>().init();
    });
  }
  checkAndRequestPermissions(OnAudioQuery audioQuery ,{bool retry = false}) async {
    // The param 'retryRequest' is false, by default.
    _hasPermission = await audioQuery.checkAndRequest(
      retryRequest: retry,
    );

    // Only call update the UI if application has all required permissions.
    _hasPermission ? setState(() {}) : null;
  }

  @override
  Widget build(BuildContext context) {
    final MainViewModel viewModel = context.watch<MainViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('music player'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: !_hasPermission
                  ? noAccessToLibraryWidget(viewModel.audioQuery)
                  : viewModel.isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : viewModel.songList.isEmpty
                          ? const Text("Nothing found!")
                          :
                          // You can use [item.data!] direct or you can create a:
                          // List<SongModel> songs = item.data!;
                          ListView(
                              children: viewModel.songList.map((e) {
                                return ListTile(
                                  onTap: () {
                                    viewModel.playMusic(
                                        path: e.getMap['_data']);
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
                            ),
            ),
          ),
          Container(
              child: StreamBuilder<bool>(
            initialData: false,
            stream: viewModel.isPlaying,
            builder: (context, snapshot) {
              if (snapshot.data == true) {
                return IconButton(
                    onPressed: () {
                      viewModel.stopMusic();
                    },
                    icon: const Icon(Icons.pause));
              } else {
                return IconButton(
                  onPressed: () {
                    viewModel.playMusic();
                  },
                  icon: const Icon(Icons.play_arrow),
                );
              }
            },
          )),
        ],
      ),
    );
  }

  Widget noAccessToLibraryWidget(OnAudioQuery audioQuery) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.redAccent.withOpacity(0.5),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Application doesn't have access to the library"),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => checkAndRequestPermissions(audioQuery , retry: true),
            child: const Text("Allow"),
          ),
        ],
      ),
    );
  }
}
