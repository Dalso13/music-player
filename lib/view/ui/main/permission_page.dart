import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../view_model/main_view_model.dart';

class PermissionPage extends StatefulWidget {
  const PermissionPage({super.key});

  @override
  State<PermissionPage> createState() => _PermissionPageState();
}

class _PermissionPageState extends State<PermissionPage> {

  @override
  Widget build(BuildContext context) {
    final MainViewModel mainViewModel = context.watch<MainViewModel>();
    return Scaffold(
      body: Center(child: Container(
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
                        title: const Text("permissions setting"),
                        content: const Text("You will need to request permission directly..."),
                        actions: <Widget>[
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop(); //창 닫기
                              openAppSettings().then((_) {
                                mainViewModel.checkPermissions().then((_) {
                                  if(mainViewModel.mainState.isPermission) {
                                    context.pop();
                                  }
                                });
                              });
                            },
                            child: const Text("close"),
                          ),
                        ],
                      );
                    }));
              },
              child: const Text("Allow"),
            ),
          ],
        ),
      )),
    );
  }
}
