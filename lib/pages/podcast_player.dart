import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../services/audio_handler.dart';
import 'package:rxdart/rxdart.dart';
import 'podcast_playback_speed_controller.dart';
import 'queue_page.dart';
import 'rich_text_editor_page.dart';
import '../models/pin.dart';
import 'package:uuid/uuid.dart';

class PodcastPlayerPage extends StatelessWidget {
  const PodcastPlayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final audioHandler = Provider.of<PodcastAudioHandler>(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, audioHandler),
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

  Widget _buildHeader(BuildContext context, PodcastAudioHandler audioHandler) {
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
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.nightlight_round),
                onPressed: () => _showSleepTimerModal(context, audioHandler),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.more_horiz),
            ],
          ),
        ],
      ),
    );
  }

  void _showSleepTimerModal(
      BuildContext context, PodcastAudioHandler audioHandler) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: const Text('10 minutes'),
              onTap: () =>
                  _setSleepTimer(context, audioHandler, Duration(minutes: 10)),
            ),
            ListTile(
              title: const Text('15 minutes'),
              onTap: () =>
                  _setSleepTimer(context, audioHandler, Duration(minutes: 15)),
            ),
            ListTile(
              title: const Text('30 minutes'),
              onTap: () =>
                  _setSleepTimer(context, audioHandler, Duration(minutes: 30)),
            ),
            ListTile(
              title: const Text('45 minutes'),
              onTap: () =>
                  _setSleepTimer(context, audioHandler, Duration(minutes: 45)),
            ),
            ListTile(
              title: const Text('1 hour'),
              onTap: () =>
                  _setSleepTimer(context, audioHandler, Duration(hours: 1)),
            ),
            ListTile(
              title: const Text('Custom time'),
              onTap: () {
                Navigator.pop(context);
                _showCustomTimeModal(context, audioHandler);
              },
            ),
            ListTile(
              title: const Text('Cancel sleep timer'),
              onTap: () => _cancelSleepTimer(context, audioHandler),
            ),
          ],
        );
      },
    );
  }

  void _showCustomTimeModal(
      BuildContext context, PodcastAudioHandler audioHandler) {
    int hours = 0;
    int minutes = 0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Set Custom Sleep Timer',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 100,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Hours'),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (value) => hours = int.tryParse(value) ?? 0,
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Minutes'),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (value) => minutes = int.tryParse(value) ?? 0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  child: const Text('Set Timer'),
                  onPressed: () {
                    Duration customDuration =
                        Duration(hours: hours, minutes: minutes);
                    _setSleepTimer(context, audioHandler, customDuration);
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _setSleepTimer(BuildContext context, PodcastAudioHandler audioHandler,
      Duration duration) {
    audioHandler.customAction('setSleepTimer', {'duration': duration});
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text('Sleep timer set for ${_formatDuration(duration)}')),
    );
  }

  void _cancelSleepTimer(
      BuildContext context, PodcastAudioHandler audioHandler) {
    audioHandler.customAction('cancelSleepTimer');
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sleep timer cancelled')),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
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
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [ 
              (mediaItem?.artUri != null)
                  ? Image.network(mediaItem?.artUri?.toString() ?? "",
                      width: 300, height: 300)
                  : Image.asset(
                      'assets/images/Podcast_doodle_illustration_1.png')
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
      padding: const EdgeInsets.all(16.0),
      child: IconButton(
        onPressed: () {
          _handleClipAudio(context, audioHandler);
        },
        icon: Image.asset(
          'assets/icons/pin.png',
          width: 72,
          height: 72,
        ),
      ),
    );
  }

  void _handleClipAudio(
      BuildContext context, PodcastAudioHandler audioHandler) {
    // Create a GlobalKey for the SnackBar
    final snackBarKey = GlobalKey<ScaffoldMessengerState>();

    // Create the SnackBar
    final snackBar = SnackBar(
      content: Row(
        children: [
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('AI is transcribing the clip',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                LinearProgressIndicator(),
                SizedBox(height: 4),
                Text('Powered by Google Cloud', style: TextStyle(fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
      duration: const Duration(days: 365), // Set a very long duration
      backgroundColor: Colors.blue.shade900,
    );

    // Show the SnackBar
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);

    // Start the transcription process
    _transcribeClip(audioHandler).then((transcription) {
      // Dismiss the SnackBar
      ScaffoldMessenger.of(context).removeCurrentSnackBar();

      if (transcription.isNotEmpty) {
        // Navigate to RichTextEditorPage
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => RichTextEditorPage(
                pin: Pin(
                    id: const Uuid().v4(),
                    title: "",
                    content: transcription,
                    tags: [""])),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to generate transcription'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }).catchError((error) {
      // Dismiss the SnackBar
      ScaffoldMessenger.of(context).removeCurrentSnackBar();

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $error'),
          duration: Duration(seconds: 3),
        ),
      );
    });
  }

  Future<String> _transcribeClip(PodcastAudioHandler audioHandler) async {
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
        throw e;
      }
    } else {
      print("Media URL is not available, cannot clip");
      throw Exception("Media URL is not available");
    }
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
