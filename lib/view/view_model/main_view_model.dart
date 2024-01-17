import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/data/reposiotry/song_repository.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MainViewModel extends ChangeNotifier {
  final SongRepository _songRepository;
  late final AudioPlayer _audioPlayer;
  List<SongModel> _songList = [];
  bool isLoading = true;
  Stream<bool>? _isPlaying;
  final OnAudioQuery _audioQuery;

  MainViewModel({
    required SongRepository songRepository,
  }) : _songRepository = songRepository, _audioQuery = songRepository.audioQuery;

  List<SongModel> get songList => _songList;


  OnAudioQuery get audioQuery => _audioQuery;

  Stream<bool>? get isPlaying => _isPlaying;

  void init() async {
    isLoading = true;
    _songList = await _songRepository.getAudioSource();
    isLoading = false;
    _audioPlayer = AudioPlayer();
    _isPlaying = _audioPlayer.playingStream;
    notifyListeners();
  }
  
  void playMusic({String? path}) async {
    if (path != null) {
      await _audioPlayer.setFilePath(path);
    }
      _audioPlayer.play();
      notifyListeners();
  }
  void stopMusic() async {
    if (_audioPlayer.playing){
      await _audioPlayer.pause();
    }
    notifyListeners();
  }

}