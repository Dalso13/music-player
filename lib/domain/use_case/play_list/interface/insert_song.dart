import 'package:music_player/domain/model/audio_model.dart';

abstract interface class InsertSong {
  void execute({required AudioModel model, required int index});
}