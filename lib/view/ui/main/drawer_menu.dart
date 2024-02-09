import 'package:flutter/material.dart';
import 'package:pristine_sound/view/ui_sealed/drawer_event.dart';
import 'package:pristine_sound/view/view_model/state/main_state.dart';
import '../../../core/screen_change_state.dart';


class DrawerMenu extends StatelessWidget {
  final MainState _state;
  final void Function(DrawerEvent event) _onTab;

  const DrawerMenu({
    super.key,
    required MainState state,
    required void Function(DrawerEvent event) onTab,
  })  : _state = state,
        _onTab = onTab;

  @override
  Widget build(BuildContext context) {
    return ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: [
        const DrawerHeader(
            child: Text(
          'Pristine Sound',
        )),
        ListTile(
          leading: const Icon(Icons.home),
          title: const Text('home'),
          selected: _state.screenChangeState == ScreenChangeState.home,
          onTap: () {
            _onTab(const DrawerEvent.homeChange());
          },
        ),
        ListTile(
          leading: const Icon(Icons.playlist_add_check),
          title: const Text('play list'),
          selected: _state.screenChangeState == ScreenChangeState.playList,
          onTap: () {
            _onTab(const DrawerEvent.playListChange());
          },
        ),
        const Divider(
          height: 1,
          thickness: 1,
        ),
        ListTile(
          leading: const Icon(Icons.more_time_rounded),
          title: const Text('sleep timer'),
          onTap: () {
            _onTab(const DrawerEvent.sleepTimerOnTap());
          }
        ),
      ],
    );
  }


}
