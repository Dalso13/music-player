import 'package:music_player/view/view_model/state/main_state.dart';

abstract interface class MainInit {
  MainState execute(Function notify);
}