import 'package:just_audio/just_audio.dart';

import '../../domain/repository/audio_repository.dart';

class AudioRepositoryImpl implements AudioRepository {
  AudioRepositoryImpl._internal();

  static final AudioRepositoryImpl _instance = AudioRepositoryImpl._internal();


  final AudioPlayer _audioPlayer = AudioPlayer();

  factory AudioRepositoryImpl() {
    return _instance;
  }

  @override
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
