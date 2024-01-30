import 'package:music_player/domain/model/audio_model.dart';

abstract interface class AddSong {
  void execute({required AudioModel model});
}