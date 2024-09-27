// ignore_for_file: avoid_print

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async'; // For Timer
import 'dart:io'; // For exit() method
import 'package:share_plus/share_plus.dart';
import 'package:just_audio/just_audio.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class MusicPlayerPage extends StatefulWidget {
  final VoidCallback toggleTheme;

  const MusicPlayerPage({super.key, required this.toggleTheme});

  @override
  State<MusicPlayerPage> createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage> {
  Timer? _timer;
  bool isTimerSet = false;
  late AudioPlayer _audioPlayer;
  bool isPlaying = false;
  bool _isClipping = false;
  String _transcription = '';
  Uint8List? _cachedAudio;
  late String audioUrl =
      'https://dcs-cached.megaphone.fm/SCIM2145176738.mp3?key=e925ed99d2a92b5c640e39df16bcddb1&request_event_id=016844ba-39f9-407d-83b7-f1257c956f77&timetoken=1724177734_C2A1DBA5D138FE3262B38153851C38B8';
  final ValueNotifier<double> _playbackSpeedNotifier = ValueNotifier(1.0);
  Duration _currentPosition = Duration.zero; // Track the current position
  late Duration _totalDuration = Duration.zero; // Track the total duration

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    // Set the audio URL (replace with your audio file)
    _audioPlayer.setUrl(audioUrl).then((_) {
      setState(() {
        _totalDuration = _audioPlayer.duration ?? Duration.zero;
      });
    });

    // Listen to changes in the audio player state (playing, paused, etc.)
    _audioPlayer.playerStateStream.listen((playerState) {
      setState(() {
        isPlaying = playerState.playing;
      });
    });

    // Listen to changes in the audio position
    _audioPlayer.positionStream.listen((position) {
      setState(() {
        _currentPosition = position;
      });
    });
  }

  // Text controllers for hours and minutes input
  final TextEditingController hoursController =
      TextEditingController(text: '01');
  final TextEditingController minutesController =
      TextEditingController(text: '00');

  // Function to schedule app closing after selected minutes
  void _scheduleAppClose(int minutes) {
    // Cancel any previous timer
    _timer?.cancel();

    // Set a new timer to close the app after [minutes] minutes
    _timer = Timer(Duration(minutes: minutes), () {
      exit(0); // Close the app
    });

    setState(() {
      isTimerSet = true;
    });

    // Notify the user
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('App will close in $minutes minutes'),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Function to cancel the timer
  void _cancelTimer() {
    if (_timer != null && _timer!.isActive) {
      _timer?.cancel();
      setState(() {
        isTimerSet = false;
      });

      // Notify the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sleep timer turned off'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  // Show the custom bottom sheet with hours and minutes input fields
  Future<void> _showCustomTimeSelector(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled:
          true, // Allow modal to expand when the keyboard pops up
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero, // No border radius as per the design
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom +
                20, // Adjust for the keyboard
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Set Custom Time',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Hours Input Field
                    SizedBox(
                      width: 80,
                      child: TextFormField(
                        controller: hoursController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Hours',
                          border: OutlineInputBorder(),
                        ),
                        textAlign: TextAlign.center,
                        onTap: () {
                          // Adjust the modal when input is focused
                        },
                      ),
                    ),
                    const SizedBox(width: 20),
                    // Colon separator
                    const Text(
                      ':',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 20),
                    // Minutes Input Field
                    SizedBox(
                      width: 80,
                      child: TextFormField(
                        controller: minutesController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Minutes',
                          border: OutlineInputBorder(),
                        ),
                        textAlign: TextAlign.center,
                        onTap: () {
                          // Adjust the modal when input is focused
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Cancel Button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Close the bottom sheet
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Colors.grey),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    // Set Button
                    ElevatedButton(
                      onPressed: () {
                        int hours = int.tryParse(hoursController.text) ?? 0;
                        int minutes = int.tryParse(minutesController.text) ?? 0;
                        int totalMinutes = (hours * 60) + minutes;

                        if (totalMinutes > 0) {
                          _scheduleAppClose(totalMinutes);
                        }
                        Navigator.pop(context); // Close the bottom sheet
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      child: const Text(
                        'Set',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  // Show the main options bottom sheet
  void _showSleeperBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero, // No border radius as per the design
      ),
      builder: (BuildContext context) {
        return SizedBox(
          height: 400,
          child: Column(
            children: [
              ListTile(
                title: const Text('Off'),
                onTap: () {
                  _cancelTimer(); // Cancel any active timer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('15 Minutes'),
                onTap: () {
                  _scheduleAppClose(15); // Close in 15 minutes
                  Navigator.pop(context); // Close the bottom sheet
                },
              ),
              ListTile(
                title: const Text('30 Minutes'),
                onTap: () {
                  _scheduleAppClose(30); // Close in 30 minutes
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('45 Minutes'),
                onTap: () {
                  _scheduleAppClose(45); // Close in 30 minutes
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('60 Minutes'),
                onTap: () {
                  _scheduleAppClose(60); // Close in 60 minutes
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Custom Time'),
                onTap: () {
                  Navigator.pop(context); // Close the bottom sheet
                  _showCustomTimeSelector(context); // Open custom time picker
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showMiscBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero, // No border radius
      ),
      builder: (BuildContext context) {
        // Get the current theme's background color
        Color? backgroundColor = Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[900] // Dark mode color
            : Colors.grey[200]; // Light mode color

        return Container(
          color: backgroundColor, // Set background based on theme
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.thumb_up,
                    color: Theme.of(context).iconTheme.color),
                title: const Text(
                  'Show more of shows like this',
                  // Adapt text color to theme
                ),
                onTap: () {
                  // Handle action
                },
              ),
              ListTile(
                leading: Icon(Icons.thumb_down,
                    color: Theme.of(context).iconTheme.color),
                title: const Text(
                  'Show less of shows like this',
                  // Adapt text color to theme
                ),
                onTap: () {
                  // Handle action
                },
              ),
              ListTile(
                leading: Icon(Icons.file_download,
                    color: Theme.of(context).iconTheme.color),
                title: const Text(
                  'Download episode', // Adapt text color to theme
                ),
                onTap: () {
                  // Handle action
                },
              ),
              ListTile(
                leading:
                    Icon(Icons.share, color: Theme.of(context).iconTheme.color),
                title: const Text(
                  'Share episode',
                ),
                onTap: () {
                  // Use the share functionality here
                  _shareEpisode();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPlaybackSpeedModal() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Playback Speed',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ValueListenableBuilder<double>(
                valueListenable: _playbackSpeedNotifier,
                builder: (context, playbackSpeed, child) {
                  return Column(
                    children: [
                      Slider(
                        value: playbackSpeed,
                        min: 0.5,
                        max: 3.0,
                        divisions: 25,
                        label: playbackSpeed.toStringAsFixed(1),
                        onChanged: (value) {
                          _playbackSpeedNotifier.value =
                              value; // Update the ValueNotifier
                          _audioPlayer.setSpeed(value); // Set the new speed
                        },
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Speed: ${playbackSpeed.toStringAsFixed(1)}x',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _shareEpisode() {
    // Sample text or URL to share
    const String episodeLink = 'https://example.com/podcast/episode/229';
    Share.share('Check out this podcast episode: $episodeLink');
  }

  Future<void> _clipAudio() async {
    setState(() {
      _isClipping = true;
      _transcription = ''; // Clear previous transcription
    });

    try {
      final duration = _audioPlayer.duration;
      final currentPosition = _audioPlayer.position;

      if (duration == null) {
        print('Audio duration is null.');
        _showErrorMessage('Audio duration is null');
        return;
      }

      double startTime = currentPosition.inSeconds.toDouble();
      double clipDuration = (duration.inSeconds - startTime > 15)
          ? 15
          : duration.inSeconds - startTime.toDouble();

      // Use cached audio if available, otherwise download
      Uint8List audioData;
      if (_cachedAudio != null) {
        audioData = _cachedAudio!;
      } else {
        final response = await http.get(Uri.parse(audioUrl));
        if (response.statusCode != 200) {
          throw Exception('Failed to download audio: ${response.statusCode}');
        }
        audioData = response.bodyBytes;
        _cachedAudio = audioData; // Cache the audio for future use
      }

      // Perform clipping on the main isolate, as FFmpegKit uses platform channels
      final clippedAudio = await _clipAudioOnMainIsolate(audioData, startTime, clipDuration);

      // Run the model on the newly clipped audio
      String transcription = await _runModelOnClippedAudio(clippedAudio);

      setState(() {
        _transcription = transcription;
      });

      _showSuccessMessage('Audio clipped and transcribed successfully!');
    } catch (e) {
      print('Error: $e');
      _showErrorMessage('An error occurred');
    } finally {
      setState(() {
        _isClipping = false;
      });
    }
  }

  // Now run FFmpegKit on the main isolate
  Future<Uint8List> _clipAudioOnMainIsolate(Uint8List audioData, double startTime, double clipDuration) async {
    // Create a temporary file for input
    final tempDir = await getTemporaryDirectory();
    final inputFile = File('${tempDir.path}/temp_input.mp3');
    await inputFile.writeAsBytes(audioData);

    // Create a temporary file for output
    final outputFile = File('${tempDir.path}/temp_output.wav');

    // Optimize FFmpeg command: use -c:a pcm_s16le for WAV output (faster than MP3)
    String ffmpegCommand = '-i ${inputFile.path} -ss $startTime -t $clipDuration -c:a pcm_s16le -ar 16000 ${outputFile.path}';

    final result = await FFmpegKit.execute(ffmpegCommand);
    final returnCode = await result.getReturnCode();

    if (ReturnCode.isSuccess(returnCode)) {
      final clippedAudio = await outputFile.readAsBytes();

      // Clean up temporary files
      await inputFile.delete();
      await outputFile.delete();

      return clippedAudio;
    } else {
      throw Exception('Error clipping audio: ${await result.getFailStackTrace()}');
    }
  }

  Future<String> _runModelOnClippedAudio(Uint8List audioData) async {
    try {
      // Load the TFLite model
      Interpreter interpreter = await Interpreter.fromAsset('conformer_model.tflite');

      // Preprocess the audio data to create input for the model
      Uint8List inputAudioData = await _preprocessAudio(audioData);

      // Prepare the input and output buffers for the model
      var input = inputAudioData.buffer.asUint8List(); // Adjust shape to match model input

      // The output shape can vary based on your model. Adjust it according to your model's output.
      var output = List.filled(100, 0).reshape([1, 100]); // Example, adjust based on your model output size

      // Run the TFLite model on the input data
      interpreter.run(input, output);

      // Convert the dynamic output into List<List<int>>
      List<List<int>> processedOutput = output.map((e) => List<int>.from(e)).toList();

      // Convert the model output into readable text
      String transcription = _processModelOutput(processedOutput);
      return transcription;

    } catch (e) {
      print('Error running model: $e');
      return 'Error during transcription';
    }
  }

  Future<Uint8List> _preprocessAudio(Uint8List audioData) async {
    // For raw PCM processing, return the audio data as is.
    // Assuming it's 16-bit PCM at 16000 Hz (as set in the FFmpeg command).
    return audioData;
  }

  String _processModelOutput(List<List<int>> output) {
    // Process the output from the TFLite model and convert it to readable text
    StringBuffer transcription = StringBuffer();

    for (int i = 0; i < output[0].length; i++) {
      int token = output[0][i];
      if (token != 0) {
        transcription.write(_mapTokenToText(token));
      }
    }

    return transcription.toString();
  }

  String _mapTokenToText(int token) {
    const List<String> vocab = [' ', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'];
    return vocab[token % vocab.length];
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    // Cancel the timer if the widget is disposed to prevent memory leaks
    _timer?.cancel();
    _playbackSpeedNotifier.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  // Fast forward function
  void fastForwardAudio() {
    final currentPosition = _audioPlayer.position;
    const forwardOffset = Duration(seconds: 10);
    final totalDuration = _audioPlayer.duration ?? Duration.zero;

    final newPosition = currentPosition + forwardOffset;
    _audioPlayer
        .seek(newPosition < totalDuration ? newPosition : totalDuration);
  }

  // Rewind function
  void rewindAudio() {
    final currentPosition = _audioPlayer.position;
    const rewindOffset = Duration(seconds: 10);
    final newPosition = currentPosition - rewindOffset;

    _audioPlayer
        .seek(newPosition > Duration.zero ? newPosition : Duration.zero);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Now Playing'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.expand_more_outlined),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.mode_night_outlined,
            ),
            onPressed: () {
              _showSleeperBottomSheet(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_horiz),
            onPressed: () {
              _showMiscBottomSheet(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius:
                  BorderRadius.circular(16.0), // Set the radius as needed
              child: CachedNetworkImage(
                imageUrl: 'https://dummyimage.com/320x320/000/fff.png',
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: 300,
                    height: 200,
                    color: Colors.white,
                  ),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fit:
                    BoxFit.cover, // Adjust how the image fits within the widget
                width: 320,
                height: 320,
              ),
            ),
            const SizedBox(height: 20),
            const Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Episode Title",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0, // Adjust the size as needed
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  "Podcast Name",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 14.0,
                      color: Color(0xFF41414e)),
                )
              ],
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.queue_music_outlined,
                        size: 28,
                      )),
                  IconButton(
                      onPressed: () {
                        rewindAudio();
                      },
                      icon: const Icon(
                        Icons.replay_10_rounded,
                        size: 28,
                      )),
                  IconButton(
                      onPressed: () {
                        if (isPlaying) {
                          _audioPlayer.pause();
                        } else {
                          _audioPlayer.play();
                        }
                      },
                      icon: Icon(
                        isPlaying
                            ? Icons.pause_circle_filled
                            : Icons.play_circle_fill_rounded,
                        size: 52,
                      )),
                  IconButton(
                      onPressed: () {
                        fastForwardAudio();
                      },
                      icon: const Icon(Icons.forward_10_rounded, size: 28)),
                  IconButton(
                      onPressed: _showPlaybackSpeedModal,
                      icon: const Icon(Icons.one_x_mobiledata, size: 28)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(formatDuration(_currentPosition)),
                  Text(formatDuration(_totalDuration)),
                ],
              ),
            ),
            // Seek bar (Slider) for audio position
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SliderTheme(
                data: const SliderThemeData(
                    thumbColor: Color(0xFF41414e),
                    thumbShape:
                        RoundSliderThumbShape(enabledThumbRadius: 4.75)),
                child: Slider(
                  value: _currentPosition.inSeconds.toDouble(),
                  min: 0,
                  max: _totalDuration.inSeconds.toDouble(),
                  onChanged: (double value) {
                    setState(() {
                      _currentPosition = Duration(seconds: value.toInt());
                    });
                    _audioPlayer.seek(_currentPosition);
                  },
                ),
              ),
            ),
            IconButton(
                onPressed: _isClipping ? null : _clipAudio,
                icon: SvgPicture.asset(
                  'assets/icons/pin.svg',
                  height: 72, // Adjust the size of the icon
                  width: 72,
                )),
            const SizedBox(height: 20),
            const Text(
              'Transcription:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  _transcription,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to format durations
  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [if (duration.inHours > 0) hours, minutes, seconds].join(':');
  }
}
