import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Class for handling podcast playback using AudioService and Just Audio
class PodcastHandler extends BaseAudioHandler with QueueHandler, SeekHandler {
  final AudioPlayer audioPlayer = AudioPlayer();
  static const String _prefsKey = 'podcast_prefs';

  // Create an audio source from a MediaItem
  UriAudioSource _createAudioSource(MediaItem item) {
    return ProgressiveAudioSource(Uri.parse(item.id));
  }

  // Listen for changes in the current podcast index and update the media item
  void _listenForCurrentPodcastIndexChanges() {
    audioPlayer.currentIndexStream.listen((index) {
      final playlist = queue.value;
      if (index == null || playlist.isEmpty) return;
      mediaItem.add(playlist[index]);
    });
  }

  // Broadcast the current playback state
  void _broadcastState(PlaybackEvent event) {
    playbackState.add(playbackState.value.copyWith(
      controls: [
        MediaControl.skipToPrevious,
        if (audioPlayer.playing) MediaControl.pause else MediaControl.play,
        MediaControl.skipToNext,
      ],
      systemActions: {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
        MediaAction.setSpeed, // Allow speed changes
      },
      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[audioPlayer.processingState]!,
      playing: audioPlayer.playing,
      updatePosition: audioPlayer.position,
      bufferedPosition: audioPlayer.bufferedPosition,
      speed: audioPlayer.speed, // Include playback speed
      queueIndex: event.currentIndex,
    ));
  }

  // Initialize the podcasts
  Future<void> initPodcasts({required List<MediaItem> episodes}) async {
    // Listen for playback events and broadcast the state
    audioPlayer.playbackEventStream.listen(_broadcastState);

    // Create a list of audio sources from the provided episodes
    final audioSource = episodes.map(_createAudioSource).toList();

    // Set the audio source of the audio player to the concatenation of the audio sources
    await audioPlayer.setAudioSource(
      ConcatenatingAudioSource(children: audioSource),
    );

    // Add the episodes to the queue
    queue.value.clear();
    queue.value.addAll(episodes);
    queue.add(queue.value);

    // Restore playback position if available
    final lastPositionData = await _getLastPlaybackPosition();
    if (lastPositionData != null) {
      await audioPlayer.seek(Duration(milliseconds: lastPositionData['duration']));
      final index = lastPositionData['index'];
      if (index != null && index < episodes.length) {
        await skipToQueueItem(index);
      }
    }

    // Listen for changes in the current podcast index
    _listenForCurrentPodcastIndexChanges();

    // Listen for processing state changes and handle end of podcast playback
    audioPlayer.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) skipToNext();
    });
  }

  // Save the last playback position for each episode
  Future<void> _savePlaybackPosition(MediaItem item) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, item.id);
    await prefs.setInt('${item.id}_duration', audioPlayer.position.inMilliseconds);
    await prefs.setInt('${item.id}_index', queue.value.indexOf(item));
  }

  // Retrieve the last playback position from shared preferences
  Future<Map<String, dynamic>?> _getLastPlaybackPosition() async {
    final prefs = await SharedPreferences.getInstance();
    final podcastId = prefs.getString(_prefsKey);
    if (podcastId != null) {
      final duration = prefs.getInt('$podcastId' + '_duration');
      final index = prefs.getInt('$podcastId' + '_index');
      return {
        'duration': duration ?? 0,
        'index': index,
      };
    }
    return null;
  }

  // Play the podcast
  @override
  Future<void> play() => audioPlayer.play();

  // Pause the podcast and save the current position
  @override
  Future<void> pause() async {
    await _savePlaybackPosition(mediaItem.value!); // Save position on pause
    await audioPlayer.pause();
  }

  // Seek to a specific position
  @override
  Future<void> seek(Duration position) => audioPlayer.seek(position);

  // Change playback speed
  @override
  Future<void> setSpeed(double speed) => audioPlayer.setSpeed(speed);

  // Skip to a specific podcast in the queue
  @override
  Future<void> skipToQueueItem(int index) async {
    await audioPlayer.seek(Duration.zero, index: index);
    play();
  }

  // Skip to the next episode
  @override
  Future<void> skipToNext() => audioPlayer.seekToNext();

  // Skip to the previous episode
  @override
  Future<void> skipToPrevious() => audioPlayer.seekToPrevious();
}
