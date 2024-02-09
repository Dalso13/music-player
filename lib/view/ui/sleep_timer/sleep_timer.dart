import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:pristine_sound/view/view_model/audio_view_model.dart';
import 'package:provider/provider.dart';

class SleepTimer extends StatelessWidget {
  final bool _oldSleepTimerEnabled;
  final int _oldHour;
  final int _oldMinutes;

  const SleepTimer({
    super.key,
    required bool oldSleepTimerEnabled,
    required int oldHour,
    required int oldMinutes,
  })  : _oldSleepTimerEnabled = oldSleepTimerEnabled,
        _oldHour = oldHour,
        _oldMinutes = oldMinutes;


  @override
  Widget build(BuildContext context) {
    final audioViewModel = context.watch<AudioViewModel>();
    final state = audioViewModel.state;
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('sleep timer'),
          Switch(
              value: state.isSleepTimerEnabled,
              onChanged: (value) => audioViewModel.changeTimerEnabled(isSleepTimerEnabled: value),
          )
        ],
      ),
      content: Row(
        children: [
          Container(
            margin: const EdgeInsets.all(8),
            child: NumberPicker(
              value: state.hour,
              minValue: 0,
              maxValue: 23,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 1),
                  top: BorderSide(width: 1),
                ),
              ),
              infiniteLoop: true,
              onChanged: (value) => audioViewModel.changeHour(hour: value),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(8),
            child: NumberPicker(
              value: state.minutes,
              step: 5,
              minValue: 5,
              maxValue: 55,
              infiniteLoop: true,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 1),
                  top: BorderSide(width: 1),
                ),
              ),
              onChanged: (value) => audioViewModel.changeMinute(minutes: value),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            context.pop(); //창 닫기
            audioViewModel.changeTimerEnabled(isSleepTimerEnabled: _oldSleepTimerEnabled);
            audioViewModel.changeHour(hour: _oldHour);
            audioViewModel.changeMinute(minutes: _oldMinutes);
          },
          child: const Text("close"),
        ),
        ElevatedButton(
          onPressed: () {
            audioViewModel.saveSleepTimer();
            context.pop(); //창 닫기
          },
          child: const Text("set"),
        ),
      ],
    );
  }

}
