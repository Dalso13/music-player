import 'package:flutter/widgets.dart';
import 'package:music_player/core/screen_change_state.dart';
import 'package:music_player/view/view_model/state/main_state.dart';
import 'package:permission_handler/permission_handler.dart';

class MainViewModel extends ChangeNotifier {
  MainState _mainState = const MainState();
  final PageController _pageController = PageController(
    initialPage: 0,
  );

  PageController get pageController => _pageController;
  MainState get mainState => _mainState;

  Future<void> init() async {
    await requestPermissions();
    notifyListeners();
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
    if (index == ScreenChangeState.playList.idx){
      _mainState = _mainState.copyWith(screenChangeState: ScreenChangeState.playList);
    } else if (index == ScreenChangeState.home.idx) {
      _mainState = _mainState.copyWith(screenChangeState: ScreenChangeState.home);
    }

    notifyListeners();
  }

  // TODO : 권한 처리
  Future<void> checkPermissions() async {
    _mainState = _mainState.copyWith(isPermissionLoading: true);
    notifyListeners();

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
    _mainState = _mainState.copyWith(isPermissionLoading: false);
    notifyListeners();
  }

  Future<void> requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.audio,
      Permission.photos,
      Permission.videos,
    ].request();
    await checkPermissions();
  }
}
