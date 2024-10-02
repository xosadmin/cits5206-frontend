import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'audio_clip_transcription_service.dart';

class PodcastAudioHandler extends BaseAudioHandler
    with QueueHandler, SeekHandler {
  final AudioPlayer _player;
  final ConcatenatingAudioSource _playlist;
  final BehaviorSubject<PlaybackState> _playbackState;
  final BehaviorSubject<MediaItem?> _mediaItem;
  final AudioClipTranscriptionService _transcriptionService;

  Timer? _sleepTimer;

  PodcastAudioHandler({
    AudioPlayer? player,
    ConcatenatingAudioSource? playlist,
    AudioClipTranscriptionService? transcriptionService,
  })  : _player = player ?? AudioPlayer(),
        _playlist = playlist ?? ConcatenatingAudioSource(children: []),
        _playbackState = BehaviorSubject<PlaybackState>.seeded(PlaybackState()),
        _mediaItem = BehaviorSubject<MediaItem?>(),
        _transcriptionService =
            transcriptionService ?? AudioClipTranscriptionService() {
    _initializeHandler();
  }

  void _initializeHandler() {
    _loadEmptyPlaylist();
    _setupEventListeners();
    _transcriptionService.preload();
  }

  Future<void> _loadEmptyPlaylist() async {
    try {
      await _player.setAudioSource(_playlist);
    } catch (e) {
      print("Error loading playlist: $e");
    }
  }

  void _setupEventListeners() {
    _listenForPlaybackEvents();
    _listenForDurationChanges();
    _listenForCurrentEpisodeChanges();
    _listenForPlaylistChanges();
  }

  void _listenForPlaybackEvents() {
    _player.playbackEventStream.listen((PlaybackEvent event) {
      final playing = _player.playing;
      playbackState.add(playbackState.value.copyWith(
        controls: [
          MediaControl.skipToPrevious,
          playing ? MediaControl.pause : MediaControl.play,
          MediaControl.stop,
          MediaControl.skipToNext,
        ],
        systemActions: const {MediaAction.seek},
        androidCompactActionIndices: const [0, 1, 3],
        processingState: _getProcessingState(),
        playing: playing,
        updatePosition: _player.position,
        bufferedPosition: _player.bufferedPosition,
        speed: _player.speed,
        queueIndex: event.currentIndex,
      ));
    });
  }

  AudioProcessingState _getProcessingState() {
    switch (_player.processingState) {
      case ProcessingState.idle:
        return AudioProcessingState.idle;
      case ProcessingState.loading:
        return AudioProcessingState.loading;
      case ProcessingState.buffering:
        return AudioProcessingState.buffering;
      case ProcessingState.ready:
        return AudioProcessingState.ready;
      case ProcessingState.completed:
        return AudioProcessingState.completed;
    }
  }

  void _listenForDurationChanges() {
    _player.durationStream.listen((duration) {
      var index = _player.currentIndex;
      final newQueue = queue.value;
      if (index == null || newQueue.isEmpty) return;
      if (_player.shuffleModeEnabled) {
        index = _player.shuffleIndices![index];
      }
      final oldMediaItem = newQueue[index];
      final newMediaItem = oldMediaItem.copyWith(duration: duration);
      newQueue[index] = newMediaItem;
      queue.add(newQueue);
      mediaItem.add(newMediaItem);
    });
  }

  void _listenForCurrentEpisodeChanges() {
    _player.currentIndexStream.listen((index) {
      final playlist = queue.value;
      if (index == null || playlist.isEmpty) return;
      if (_player.shuffleModeEnabled) {
        index = _player.shuffleIndices![index];
      }
      mediaItem.add(playlist[index]);
    });
  }

  void _listenForPlaylistChanges() {
    _player.sequenceStateStream.listen((SequenceState? sequenceState) {
      final sequence = sequenceState?.effectiveSequence;
      if (sequence == null || sequence.isEmpty) return;
      final items = sequence.map((source) => source.tag as MediaItem);
      queue.add(items.toList());
    });
  }

  @override
  Future<void> addQueueItems(List<MediaItem> mediaItems) async {
    final audioSources = mediaItems
        .map((item) => AudioSource.uri(Uri.parse(item.id), tag: item))
        .toList();
    await _playlist.addAll(audioSources);

    final newQueue = queue.value..addAll(mediaItems);
    queue.add(newQueue);
  }

  @override
  Future<void> addQueueItem(MediaItem mediaItem) async {
    await _playlist
        .add(AudioSource.uri(Uri.parse(mediaItem.id), tag: mediaItem));

    final newQueue = queue.value..add(mediaItem);
    queue.add(newQueue);
  }

  @override
  Future<void> removeQueueItemAt(int index) async {
    await _playlist.removeAt(index);

    final newQueue = queue.value..removeAt(index);
    queue.add(newQueue);
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> skipToQueueItem(int index) async {
    if (index < 0 || index >= queue.value.length) return;
    if (_player.shuffleModeEnabled) {
      index = _player.shuffleIndices!.indexOf(index);
    }
    await _player.seek(Duration.zero, index: index);
  }

  @override
  Future<void> skipToNext() => _player.seekToNext();

  @override
  Future<void> skipToPrevious() => _player.seekToPrevious();

  @override
  Future<void> setRepeatMode(AudioServiceRepeatMode repeatMode) async {
    switch (repeatMode) {
      case AudioServiceRepeatMode.none:
        await _player.setLoopMode(LoopMode.off);
        break;
      case AudioServiceRepeatMode.one:
        await _player.setLoopMode(LoopMode.one);
        break;
      case AudioServiceRepeatMode.all:
      case AudioServiceRepeatMode.group:
        await _player.setLoopMode(LoopMode.all);
        break;
    }
  }

  @override
  Future<void> setShuffleMode(AudioServiceShuffleMode shuffleMode) async {
    if (shuffleMode == AudioServiceShuffleMode.none) {
      await _player.setShuffleModeEnabled(false);
    } else {
      await _player.shuffle();
      await _player.setShuffleModeEnabled(true);
    }
  }

  @override
  Future<void> customAction(String name, [Map<String, dynamic>? extras]) async {
    switch (name) {
      case 'dispose':
        await _dispose();
        break;
      case 'transcribeClip':
        await _transcribeClip(extras);
        break;
      case 'setSleepTimer':
        _setSleepTimer(extras?['duration'] as Duration?);
        break;
      case 'cancelSleepTimer':
        _cancelSleepTimer();
        break;
    }
  }

  Future<void> _dispose() async {
    await _player.dispose();
    await _playbackState.close();
    await _mediaItem.close();
    await super.stop();
  }

  Future<void> _transcribeClip(Map<String, dynamic>? extras) async {
    final url = extras?['url'] as String?;
    final start = extras?['start'] as Duration?;
    final end = extras?['end'] as Duration?;
    if (url != null && start != null && end != null) {
      await _transcriptionService.clipAndTranscribe(url, start, end);
    }
  }

  void _setSleepTimer(Duration? duration) {
    if (duration == null) return;
    _cancelSleepTimer();
    _sleepTimer = Timer(duration, stop);
  }

  void _cancelSleepTimer() {
    _sleepTimer?.cancel();
    _sleepTimer = null;
  }

  @override
  Future<void> stop() async {
    await _player.stop();
    return super.stop();
  }
}
