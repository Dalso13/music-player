import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:music_player/view/ui/play_screen/now_play_music_screen.dart';
import 'package:music_player/view/ui/audio_part/audio_bar.dart';
import 'package:music_player/view/view_model/main_view_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../main_part/music_list_view.dart';

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
      if (_hasPermission) {
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
  }

  @override
  Widget build(BuildContext context) {
    final MainViewModel viewModel = context.watch<MainViewModel>();
    final state = viewModel.mainState;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Music Player'),
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
                        : state.songList.isEmpty
                            ? const Text("Nothing found!")
                            : const MusicListView()),
          ),
          state.nowPlaySong.id < 0
              ? Container()
              : GestureDetector(
                  onTap: () {
                    final myModel =
                        Provider.of<MainViewModel>(context, listen: false);
                    showModalBottomSheet(
                      isScrollControlled: true,
                        context: context,
                        builder: (context) {
                          return ChangeNotifierProvider.value(
                              value: myModel,
                              child: const NowPlayMusicScreen());
                        });
                  },
                  child: const AudioBar(),),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        onPressed: viewModel.shufflePlayList,
        child: Icon(Icons.shuffle),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndDocked,
      bottomNavigationBar: Container(
        width: double.maxFinite,
        height: 60,
        child: const InkWell(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Icon(Icons.home, color: Colors.deepPurple),
                Text('home'),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void goRouters() {
    final myModel =
    Provider.of<MainViewModel>(context, listen: false);
    showMaterialModalBottomSheet(
        context: context,
        builder: (context) {
          return ChangeNotifierProvider.value(
              value: myModel,
              child: const NowPlayMusicScreen());
        });
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
            onPressed: () {
              showDialog(
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
                  }));
            },
            child: const Text("Allow"),
          ),
        ],
      ),
    );
  }
}
