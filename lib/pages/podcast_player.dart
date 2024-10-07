import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import '../services/audio_handler.dart';
import 'package:rxdart/rxdart.dart';
import 'podcast_playback_speed_controller.dart';
import 'queue_page.dart';
import 'rich_text_editor_page.dart';

class PodcastPlayerPage extends StatelessWidget {
  const PodcastPlayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final audioHandler = Provider.of<PodcastAudioHandler>(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            _buildNowPlaying(audioHandler),
            _buildEpisodeInfo(audioHandler),
            _buildProgressBar(audioHandler),
            _buildPlaybackControls(audioHandler),
            _buildClippingButton(context, audioHandler), // New Clipping Button
            _buildBottomTabs(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.keyboard_arrow_down),
            onPressed: () => Navigator.pop(context),
          ),
          const Text('Now Playing',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const Row(
            children: [
              Icon(Icons.nightlight_round),
              SizedBox(width: 16),
              Icon(Icons.more_horiz),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNowPlaying(PodcastAudioHandler audioHandler) {
    return StreamBuilder<MediaItem?>(
      stream: audioHandler.mediaItem,
      builder: (context, snapshot) {
        final mediaItem = snapshot.data;
        return Container(
          width: 300,
          height: 300,
          margin: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: const Color(0xFF2C5364),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lightbulb_outline,
                  color: Colors.yellow, size: 80),
              const SizedBox(height: 16),
              Text(
                mediaItem?.album ?? 'THE LAZY GENIUS',
                style: const TextStyle(
                    color: Colors.yellow,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEpisodeInfo(PodcastAudioHandler audioHandler) {
    return StreamBuilder<MediaItem?>(
      stream: audioHandler.mediaItem,
      builder: (context, snapshot) {
        final mediaItem = snapshot.data;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Text(
                mediaItem?.title ?? 'Episode Title',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(mediaItem?.artist ?? 'Podcast Name',
                  style: const TextStyle(color: Colors.grey)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProgressBar(PodcastAudioHandler audioHandler) {
    return StreamBuilder<MediaState>(
      stream: mediaStateStream(audioHandler),
      builder: (context, snapshot) {
        final mediaState = snapshot.data;
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Slider(
                value: mediaState?.position.inMilliseconds.toDouble() ?? 0.0,
                onChanged: (value) {
                  audioHandler.seek(Duration(milliseconds: value.round()));
                },
                min: 0.0,
                max: mediaState?.mediaItem?.duration?.inMilliseconds
                        .toDouble() ??
                    1.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_formatDuration(mediaState?.position ?? Duration.zero)),
                  Text(_formatDuration(
                      mediaState?.mediaItem?.duration ?? Duration.zero)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPlaybackControls(PodcastAudioHandler audioHandler) {
    return StreamBuilder<PlaybackState>(
      stream: audioHandler.playbackState,
      builder: (context, snapshot) {
        final playbackState = snapshot.data;
        final playing = playbackState?.playing ?? false;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.queue_music, size: 30),
                  onPressed: () => _openQueuePage(context, audioHandler),
                ),
                IconButton(
                  icon: const Icon(Icons.replay_10, size: 30),
                  onPressed: () => audioHandler.seek(
                    Duration(
                        seconds: (playbackState?.position.inSeconds ?? 0) - 10),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.skip_previous, size: 30),
                  onPressed: audioHandler.skipToPrevious,
                ),
                Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.orange,
                  ),
                  child: IconButton(
                    icon: Icon(playing ? Icons.pause : Icons.play_arrow,
                        color: Colors.white, size: 40),
                    onPressed: playing ? audioHandler.pause : audioHandler.play,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.skip_next, size: 30),
                  onPressed: audioHandler.skipToNext,
                ),
                IconButton(
                  icon: const Icon(Icons.forward_10, size: 30),
                  onPressed: () => audioHandler.seek(
                    Duration(
                        seconds: (playbackState?.position.inSeconds ?? 0) + 10),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.speed, size: 30),
                  onPressed: () =>
                      _showPlaybackSpeedModal(context, audioHandler),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _openQueuePage(BuildContext context, PodcastAudioHandler audioHandler) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => QueuePage(audioHandler: audioHandler),
    ));
  }

  void _showPlaybackSpeedModal(
      BuildContext context, PodcastAudioHandler audioHandler) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return PlaybackSpeedSelector(audioHandler: audioHandler);
      },
    );
  }

Widget _buildClippingButton(
    BuildContext context, PodcastAudioHandler audioHandler) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 16.0),
    child: ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return FutureBuilder<String>(
              future: _handleClipAudio(audioHandler),  // Use the future here
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Show loading dialog while the future is being processed
                  return AlertDialog(
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 20),
                        const Text(
                          'AI is transcribing the clip',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return const LinearGradient(
                              colors: [Colors.blue, Colors.green],
                              tileMode: TileMode.mirror,
                            ).createShader(bounds);
                          },
                          child: const Text(
                            'Please Wait...',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                            'Powered by Google Cloud',
                            style: TextStyle(
                              fontSize: 10,
                            ),
                          ),
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  // Close the dialog and show error if any
                  Navigator.of(context).pop();
                  SchedulerBinding.instance.addPostFrameCallback((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: ${snapshot.error}')),
                    );
                  });
                  return const SizedBox();  // Return an empty widget
                } else if (snapshot.hasData) {
                  // Close the dialog and navigate if transcription is successful
                  Navigator.of(context).pop(); // Close loading dialog
                  String transcription = snapshot.data!;

                  SchedulerBinding.instance.addPostFrameCallback((_) {
                    if (transcription.isNotEmpty) {
                      // Navigate to RichTextEditorPage
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              RichTextEditorPage(initialText: transcription),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Failed to generate transcription'),
                        ),
                      );
                    }
                  });

                  return const SizedBox();  // Return an empty widget
                } else {
                  // If no data was returned, simply return an empty container
                  return const SizedBox();
                }
              },
            );
          },
        );
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
        child: Text('Clip Audio', style: TextStyle(fontSize: 18)),
      ),
    ),
  );
}



  Future<String> _handleClipAudio(PodcastAudioHandler audioHandler) async {
    final mediaItem = audioHandler.mediaItem.value;
    final currentPosition = audioHandler.playbackState.value.position;

    if (mediaItem == null || mediaItem.duration == null) {
      print('No valid media item or media duration');
      return "";
    }

    const clipDuration = Duration(seconds: 15);
    final startPosition = currentPosition - clipDuration;
    final endPosition = currentPosition + clipDuration;

    final validStart = startPosition.isNegative ? Duration.zero : startPosition;
    final validEnd =
        (endPosition > mediaItem.duration!) ? mediaItem.duration! : endPosition;

    final mediaUrl = mediaItem.extras?['url'] ?? mediaItem.id;

    if (mediaUrl != null) {
      try {
        String transcription =
            await audioHandler.customAction('transcribeClip', {
          'url': mediaUrl,
          'start': validStart,
          'end': validEnd,
        });
        print("Transcription - podplayer: $transcription");
        return transcription;
      } catch (e) {
        print("Error during transcription - podplayer: $e");
        return "";
      }
    } else {
      print("Media URL is not available, cannot clip");
    }
    return "";
  }

  Widget _buildBottomTabs() {
    return Expanded(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.description),
                  Text('Description'),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.push_pin),
                  Text('Pins'),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.mic),
                  Text('Transcription'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}

Stream<MediaState> mediaStateStream(PodcastAudioHandler audioHandler) =>
    Rx.combineLatest2<MediaItem?, Duration, MediaState>(
        audioHandler.mediaItem,
        AudioService.position,
        (mediaItem, position) => MediaState(mediaItem, position));

class MediaState {
  final MediaItem? mediaItem;
  final Duration position;

  MediaState(this.mediaItem, this.position);
}
