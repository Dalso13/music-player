import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:music_player/core/screen_change_state.dart';
import 'package:music_player/domain/use_case/custom_play_list_box/interface/custom_play_list_data_check.dart';
import 'package:music_player/view/view_model/state/main_state.dart';
import 'package:permission_handler/permission_handler.dart';

class MainViewModel extends ChangeNotifier {
  MainState _mainState = const MainState();
  final PageController _pageController = PageController(
    initialPage: 0,
  );
  final TextEditingController _textEditingController = TextEditingController();
  // useCase
  final CustomPlayListDataCheck _customPlayListDataCheck;

  // useCase
  MainViewModel({
    required CustomPlayListDataCheck customPlayListDataCheck,
  })  : _customPlayListDataCheck = customPlayListDataCheck;


  PageController get pageController => _pageController;

  MainState get mainState => _mainState;

  TextEditingController get textEditingController => _textEditingController;

  Future<void> init() async {
    await requestPermissions();
    notifyListeners();
  }

  void dataCheck() {
    _customPlayListDataCheck.execute();
  }

  void homeChange() {
    if (_mainState.screenChangeState == ScreenChangeState.home) return;
    _mainState = _mainState.copyWith(screenChangeState: ScreenChangeState.home);
    _buttonPageChange();
    notifyListeners();
  }

  void playListChange() {
    if (_mainState.screenChangeState == ScreenChangeState.playList) return;
    _mainState =
        _mainState.copyWith(screenChangeState: ScreenChangeState.playList);
    _buttonPageChange();
    notifyListeners();
  }

  void _buttonPageChange() {
    _pageController.animateToPage(_mainState.screenChangeState.idx,
        duration: const Duration(milliseconds: 500), curve: Curves.ease);
  }

  void scrollPageChange({required int index}) {
    if (index == ScreenChangeState.playList.idx) {
      _mainState =
          _mainState.copyWith(screenChangeState: ScreenChangeState.playList);
    } else if (index == ScreenChangeState.home.idx) {
      _mainState =
          _mainState.copyWith(screenChangeState: ScreenChangeState.home);
    }

    notifyListeners();
  }



  // TODO : 권한 처리
  Future<void> checkPermissions() async {
    _mainState = _mainState.copyWith(isPermissionLoading: true);
    notifyListeners();
    final device = await _getDeviceInfo();

    if (int.parse(device['version']) > 12){
      if (await Permission.audio.isGranted &&
          await Permission.photos.isGranted &&
          await Permission.videos.isGranted) {
        _mainState = _mainState.copyWith(
          isPermission: true,
        );
      } else {
        _mainState = _mainState.copyWith(
          isPermission: false,
        );
      }
    } else {
      if (await Permission.storage.isGranted) {
        _mainState = _mainState.copyWith(
          isPermission: true,
        );
      } else {
        _mainState = _mainState.copyWith(
          isPermission: false,
        );
      }
    }
    _mainState = _mainState.copyWith(isPermissionLoading: false);
    notifyListeners();
  }

  Future<void> requestPermissions() async {
    final device = await _getDeviceInfo();
    if (int.parse(device['version']) > 12){
      await [
        Permission.audio,
        Permission.photos,
        Permission.videos,
      ].request();
    } else {
      await [
        Permission.storage,
      ].request();
    }

    await checkPermissions();
  }


  Future<Map<String, dynamic>> _getDeviceInfo() async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    Map<String, dynamic> deviceData = <String, dynamic>{};

    try {
      if (Platform.isAndroid) {
        deviceData = _readAndroidDeviceInfo(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
    } catch(error) {
      deviceData = {
        "Error": "Failed to get platform version."
      };
    }

    return deviceData;
  }

  Map<String, dynamic> _readAndroidDeviceInfo(AndroidDeviceInfo info) {
    var release = info.version.release;
    var manufacturer = info.manufacturer;
    var model = info.model;

    return {
      "version": release,
      "device": "$manufacturer $model",
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo info) {
    var systemName = info.systemName;
    var version = info.systemVersion;
    var machine = info.utsname.machine;

    return {
      "version": version,
      "device": machine,
    };
  }



  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _textEditingController.dispose();
    _pageController.dispose();
    super.dispose();
  }
}
