import 'package:audio_service/audio_service.dart';

abstract interface class ShuffleChange {
  Future<void> execute({required AudioServiceShuffleMode shuffleMode});
}