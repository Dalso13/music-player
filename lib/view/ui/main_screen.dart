import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:music_player/view/view_model/main_view_model.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../view_model/state/progress_bar_state.dart';


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
    checkAndRequestPermissions().then((_) {
      if (_hasPermission){
        Future.microtask(() {
          context.read<MainViewModel>().init();
        });
      }
    });
  }
  Future<void> checkAndRequestPermissions({bool retry = false}) async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.audio,
      Permission.photos,
      Permission.videos,
    ].request();

    if (await Permission.audio.isGranted &&
        await Permission.photos.isGranted &&
        await Permission.videos.isGranted) {
      _hasPermission = true;
    }
    setState(() {

    });
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
                  ? noAccessToLibraryWidget()
                  : viewModel.mainState.isLoading
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
          Column(
            children: [
              ValueListenableBuilder<ProgressBarState>(
                valueListenable: viewModel.progressNotifier,
                builder: (_, value, __) {
                  return ProgressBar(
                    progress: value.current,
                    buffered: value.buffered,
                    total: value.total,
                    onSeek: viewModel.seek,
                  );
                },
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
        ],
      ),
    );
  }

  Widget noAccessToLibraryWidget() {
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
            onPressed: () {showDialog(
                context: context,
                barrierDismissible: false, //바깥 영역 터치시 닫을지 여부 결정
                builder: ((context) {
              return AlertDialog(
                title: Text("권한 요청"),
                content: Text("권한을 직접 요청하셔야 합니다."),
                actions: <Widget>[
                  Container(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(); //창 닫기
                        openAppSettings().then((_) {
                          checkAndRequestPermissions();
                        });
                      },
                      child: Text("닫기"),
                    ),
                  ),
                ],
              );
            }));},
            child: const Text("Allow"),
          ),
        ],
      ),
    );
  }
}
