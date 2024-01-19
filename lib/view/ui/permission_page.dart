import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionPage extends StatefulWidget {
  const PermissionPage({super.key});

  @override
  State<PermissionPage> createState() => _PermissionPageState();
}

class _PermissionPageState extends State<PermissionPage> {
  bool _hasPermission = false;

  @override
  void initState() {
    super.initState();

    checkAndRequestPermissions().then((_) {
      if(_hasPermission){
        Future.microtask(() {
          context.push('/');
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
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !_hasPermission
          ? noAccessToLibraryWidget()
          : Center(),
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
                                checkAndRequestPermissions().then((_) {
                                  if(_hasPermission){
                                    context.push('/');
                                  }
                                });
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
