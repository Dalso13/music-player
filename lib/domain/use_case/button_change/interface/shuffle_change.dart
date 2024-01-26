import 'package:audio_service/audio_service.dart';

abstract interface class ShuffleChange {
  Future<bool> execute({required bool isShuffleModeEnabled});
}