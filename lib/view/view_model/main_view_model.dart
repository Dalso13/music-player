import 'package:flutter/widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pristine_sound/view/view_model/state/main_state.dart';

import '../../core/screen_change_state.dart';
import '../../domain/use_case/custom_play_list_box/interface/custom_play_list_data_check.dart';
import '../../domain/use_case/get_device_data/get_device_data.dart';

class MainViewModel extends ChangeNotifier {
  MainState _mainState = const MainState();
  final PageController _pageController = PageController(
    initialPage: 0,
  );

  // useCase
  final CustomPlayListDataCheck _customPlayListDataCheck;
  final GetDeviceData _getDeviceData;

  // useCase

  MainViewModel({
    required CustomPlayListDataCheck customPlayListDataCheck,
    required GetDeviceData getDeviceData,
  })  : _customPlayListDataCheck = customPlayListDataCheck,
        _getDeviceData = getDeviceData;

  PageController get pageController => _pageController;

  MainState get mainState => _mainState;

  Future<void> init() async {
    final checkPermission = await _permission();
    if (checkPermission == false) {
      await requestPermissions();
    } else {
      await checkPermissions();
    }
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
    final checkPermission = await _permission();

    _mainState = _mainState.copyWith(
      isPermissionLoading: false,
      isPermission: checkPermission,
    );
    notifyListeners();
  }

  Future<void> requestPermissions() async {
    final device = await _getDeviceData.execute();
    // 버전이 3.1.0 이런식으로 들어올때도 있어서 그냥 int로 바꾸기
    String version = device['version'];
    int index = version.indexOf('.');
    if (index > -1) {
      version = version.substring(0,index);
    }

   if (int.parse(version) >= 13) {
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

  Future<bool> _permission() async {
    _mainState = _mainState.copyWith(isPermissionLoading: true);
    notifyListeners();
    final device = await _getDeviceData.execute();

    String version = device['version'];
    int index = version.indexOf('.');
    if (index > -1) {
      version = version.substring(0,index);
    }

    if (int.parse(version) >= 13) {
      if (await Permission.audio.isGranted &&
          await Permission.photos.isGranted &&
          await Permission.videos.isGranted) {
        return true;
      } else {
        return false;
      }
    } else {
      if (await Permission.storage.isGranted) {
        return true;
      } else {
        return false;
      }
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _pageController.dispose();
    super.dispose();
  }
}
