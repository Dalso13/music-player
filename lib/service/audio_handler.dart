import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/data/repository/audio_repository_impl.dart';

Future<AudioHandler> initAudioService() async {
  return await AudioService.init(
    builder: () => MyAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.mycompany.myapp.audio',
      androidNotificationChannelName: 'Audio Service Demo',
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: true,
    ),
  );
}

class MyAudioHandler extends BaseAudioHandler {
  final _player = AudioRepositoryImpl().audioPlayer;
  final _playlist = ConcatenatingAudioSource(children: []);

  MyAudioHandler() {
    _loadEmptyPlaylist();
    _notifyAudioHandlerAboutPlaybackEvents();
    _listenForDurationChanges();
    _listenForCurrentSongIndexChanges();
    _listenForSequenceStateChanges();

  }

  Future<void> _loadEmptyPlaylist() async {
    try {
      await _player.setAudioSource(_playlist);
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Future<void> addQueueItems(List<MediaItem> mediaItems) async {
    await _player.setShuffleModeEnabled(false);
    if (_player.playing){
      await _player.pause();
    }
    final audioSource = mediaItems.map(_createAudioSource);
    _playlist.clear();
    _playlist.addAll(audioSource.toList());

    queue.add(mediaItems);
  }

  @override
  Future<void> addQueueItem(MediaItem mediaItem) async {
    // manage Just Audio
    final audioSource = _createAudioSource(mediaItem);
    _playlist.add(audioSource);

    // notify system
    final newQueue = queue.value..add(mediaItem);
    queue.add(newQueue);
  }


  @override
  Future<void> insertQueueItem(int index, MediaItem mediaItem) async {
    // manage Just Audio
    index++;
    final audioSource = _createAudioSource(mediaItem);
    if (_player.shuffleModeEnabled) {
      // TODO: 서플 모드일때 로직이 너무 어려워서 힘들다...
      // _playlist.insert(index,audioSource);

      //final newQueue = queue.value..insert(index,mediaItem);
      //queue.add(newQueue);
    } else {
      _playlist.insert(index,audioSource);
      final newQueue = queue.value..insert(index, mediaItem);
      queue.add(newQueue);
    }

  }

  UriAudioSource _createAudioSource(MediaItem mediaItem) {
    return AudioSource.file(
      mediaItem.extras!['url'] as String,
      tag: mediaItem,
    );
  }

  @override
  Future<void> skipToQueueItem(int index) async {
    await _player.setAudioSource(_playlist, initialIndex: index);
  }

  void _notifyAudioHandlerAboutPlaybackEvents() {
    _player.playbackEventStream.listen((PlaybackEvent event) {
      final playing = _player.playing;
      playbackState.add(playbackState.value.copyWith(
        controls: [
          MediaControl.skipToPrevious,
          if (playing) MediaControl.pause else MediaControl.play,
          MediaControl.stop,
          MediaControl.skipToNext,
        ],
        systemActions: const {
          MediaAction.seek,
        },
        androidCompactActionIndices: const [0, 1, 3],
        processingState: const {
          ProcessingState.idle: AudioProcessingState.idle,
          ProcessingState.loading: AudioProcessingState.loading,
          ProcessingState.buffering: AudioProcessingState.buffering,
          ProcessingState.ready: AudioProcessingState.ready,
          ProcessingState.completed: AudioProcessingState.completed,
        }[_player.processingState]!,
        playing: playing,
        updatePosition: _player.position,
        bufferedPosition: _player.bufferedPosition,
        speed: _player.speed,
        queueIndex: event.currentIndex,
        repeatMode: const {
          LoopMode.off: AudioServiceRepeatMode.none,
          LoopMode.one: AudioServiceRepeatMode.one,
          LoopMode.all: AudioServiceRepeatMode.all,
        }[_player.loopMode]!,
        shuffleMode: (_player.shuffleModeEnabled)
            ? AudioServiceShuffleMode.all
            : AudioServiceShuffleMode.none,
      ));
    });
  }

  void _listenForDurationChanges() {
    _player.durationStream.listen((duration) {
      var index = _player.currentIndex;
      final newQueue = queue.value;
      if (index == null || newQueue.isEmpty) return;
      if (_player.shuffleModeEnabled) {
        index = _player.shuffleIndices!.indexOf(index);
      }
      final oldMediaItem = newQueue[index];
      final newMediaItem = oldMediaItem.copyWith(duration: duration);
      newQueue[index] = newMediaItem;
      queue.add(newQueue);
      mediaItem.add(newMediaItem);
    });
  }

  void _listenForCurrentSongIndexChanges() {
    _player.currentIndexStream.listen((index) {
      final playlist = queue.value;
      if (index == null || playlist.isEmpty) return;
      if (_player.shuffleModeEnabled) {
        index = _player.shuffleIndices!.indexOf(index);
      }
      mediaItem.add(playlist[index]);
    });
  }


  void _listenForSequenceStateChanges() {
    _player.sequenceStateStream.listen((SequenceState? sequenceState) {
      final sequence = sequenceState?.effectiveSequence;
      if (sequence == null || sequence.isEmpty) return;
      final items = sequence.map((source) => source.tag as MediaItem).toList();
      queue.add(items);
    });
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> skipToNext() => _player.seekToNext();

  @override
  Future<void> skipToPrevious() => _player.seekToPrevious();

  @override
  Future<void> setRepeatMode(AudioServiceRepeatMode repeatMode) async {
    switch (repeatMode) {
      case AudioServiceRepeatMode.none:
        _player.setLoopMode(LoopMode.off);
        break;
      case AudioServiceRepeatMode.one:
        _player.setLoopMode(LoopMode.one);
        break;
      case AudioServiceRepeatMode.group:
      case AudioServiceRepeatMode.all:
        _player.setLoopMode(LoopMode.all);
        break;
    }
  }

  @override
  Future<void> removeQueueItemAt(int index) async {
    _playlist.removeAt(index);
    // notify system
    final newQueue = queue.value..removeAt(index);
    queue.add(newQueue);
  }

  // TODO: 셔플 사용후 곡추가 때문에 만들어 보았지만 안될거같음..
  //   List<AudioSource> _oldPlayList = [];
  // @override
  // Future<void> setShuffleMode(AudioServiceShuffleMode shuffleMode) async {
  //   switch (shuffleMode) {
  //     case AudioServiceShuffleMode.none:
  //       _playlist.clear();
  //       await _playlist.addAll(_oldPlayList);
  //       _oldPlayList.clear();
  //       break;
  //     case AudioServiceShuffleMode.group:
  //     case AudioServiceShuffleMode.all:
  //       _oldPlayList.addAll(_playlist.children);
  //       await _player.setShuffleModeEnabled(true);
  //       _player.shuffle();
  //      // final playlist = _player.shuffleIndices!.map((index) => queue.value[index]).toList();
  //       final newPlayList = _player.shuffleIndices!.map((index) => _playlist.children[index]).toList();
  //      await  _player.setShuffleModeEnabled(false);
  //       _playlist.clear();
  //       await _playlist.addAll(newPlayList);
  //    //   queue.add(playlist);
  //       break;
  //   }
  // }


  @override
  Future<void> setShuffleMode(AudioServiceShuffleMode shuffleMode) async {
    final oldIndices = _player.effectiveIndices!;
    switch (shuffleMode) {
      case AudioServiceShuffleMode.none:
        final list = List.generate(
            oldIndices.length, (index) => queue.value[oldIndices[index]]);
        queue.add(list);
        await _player.setShuffleModeEnabled(false);
        break;
      case AudioServiceShuffleMode.group:
      case AudioServiceShuffleMode.all:
        _player.setShuffleModeEnabled(true);
        _player.shuffle();
        final playlist =
        _player.shuffleIndices!.map((index) => queue.value[index]).toList();
        queue.add(playlist);
        break;
    }
  }




  @override
  Future<void> customAction(String name, [Map<String, dynamic>? extras]) async {
    if (name == 'dispose') {
      await _player.dispose();
      super.stop();
    }
  }

  @override
  Future<void> stop() async {
    await _player.stop();
    return super.stop();
  }
}
