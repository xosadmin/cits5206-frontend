import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/audio_handler.dart';
import 'package:rxdart/rxdart.dart';

class PodcastPlayerPage extends StatelessWidget {
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
            icon: Icon(Icons.keyboard_arrow_down),
            onPressed: () => Navigator.pop(context),
          ),
          Text('Now Playing', style: TextStyle(fontWeight: FontWeight.bold)),
          Row(
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
          margin: EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: Color(0xFF2C5364),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lightbulb_outline, color: Colors.yellow, size: 80),
              SizedBox(height: 16),
              Text(
                mediaItem?.album ?? 'THE LAZY GENIUS',
                style: TextStyle(color: Colors.yellow, fontSize: 24, fontWeight: FontWeight.bold),
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
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(mediaItem?.artist ?? 'Podcast Name', style: TextStyle(color: Colors.grey)),
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
                max: mediaState?.mediaItem?.duration?.inMilliseconds.toDouble() ?? 1.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_formatDuration(mediaState?.position ?? Duration.zero)),
                  Text(_formatDuration(mediaState?.mediaItem?.duration ?? Duration.zero)),
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
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.replay_10, size: 40),
              onPressed: () => audioHandler.seek(
                  Duration(seconds: (playbackState?.position.inSeconds ?? 0) - 15)),
            ),
            SizedBox(width: 32),
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.orange,
              ),
              child: IconButton(
                icon: Icon(playing ? Icons.pause : Icons.play_arrow, color: Colors.white, size: 40),
                onPressed: playing ? audioHandler.pause : audioHandler.play,
              ),
            ),
            SizedBox(width: 32),
            IconButton(
              icon: Icon(Icons.forward_10, size: 40),
              onPressed: () => audioHandler.seek(
                  Duration(seconds: (playbackState?.position.inSeconds ?? 0) + 15)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBottomTabs() {
    return Expanded(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Row(
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