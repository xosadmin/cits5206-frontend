import 'package:flutter/material.dart';
import '../services/audio_handler.dart';


class PlaybackSpeedSelector extends StatefulWidget {
  final PodcastAudioHandler audioHandler;

  const PlaybackSpeedSelector({Key? key, required this.audioHandler}) : super(key: key);

  @override
  _PlaybackSpeedSelectorState createState() => _PlaybackSpeedSelectorState();
}

class _PlaybackSpeedSelectorState extends State<PlaybackSpeedSelector> {
  double _currentSpeed = 1.0;

  @override
  void initState() {
    super.initState();
    widget.audioHandler.playbackState.listen((state) {
      setState(() {
        _currentSpeed = state.speed;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: Column(
        children: [
          Text('Playback Speed: ${_currentSpeed.toStringAsFixed(1)}x'),
          Slider(
            min: 1.0,
            max: 3.0,
            divisions: 20,
            value: _currentSpeed,
            onChanged: (value) {
              setState(() {
                _currentSpeed = value;
              });
              widget.audioHandler.setSpeed(value);
            },
          ),
        ],
      ),
    );
  }
}