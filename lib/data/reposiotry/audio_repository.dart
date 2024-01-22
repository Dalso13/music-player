import 'package:just_audio/just_audio.dart';

class AudioRepository {
  AudioRepository._internal();

  static final AudioRepository _instance = AudioRepository._internal();
  static final AudioPlayer _audioPlayer = AudioPlayer();

  factory AudioRepository() {
    return _instance;
  }

  AudioPlayer get audioPlayer => _audioPlayer;
}

// class AudioRepository {
//
//   static AudioRepository? _instance;
//   static final AudioPlayer _audioPlayer = AudioPlayer();
//
//   AudioRepository._internal();
//
//   static AudioRepository? get getInstance {
//     _instance ??= AudioRepository._internal();
//     return _instance;
//   }
//
//   AudioPlayer get audioPlayer => _audioPlayer;
// }
