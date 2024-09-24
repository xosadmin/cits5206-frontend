// ignore_for_file: avoid_print

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async'; // For Timer
import 'dart:io'; // For exit() method
import 'package:share_plus/share_plus.dart';
import 'package:just_audio/just_audio.dart';
import 'package:http/http.dart' as http;
// import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:permission_handler/permission_handler.dart';

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
  String audioUrl =
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
    // Request permission to access external storage
    var status = await Permission.storage.request();
    if (status.isGranted) {
      setState(() {
        _isClipping = true;
      });

      try {
        // Get the duration of the currently playing audio
        final duration = _audioPlayer.duration;
        if (duration == null) {
          if (kDebugMode) {
            print('Audio duration is null.');
          }
          return;
        }

        // Start time (where to clip from)
        double startTime = _audioPlayer.position.inSeconds.toDouble();
        // Duration to clip (15 seconds or the remaining audio duration)
        double clipDuration = (duration.inSeconds - startTime > 15)
            ? 15
            : duration.inSeconds - startTime.toDouble();

        // Get the app's media directory (or replace with getExternalStorageDirectory())
        Directory? mediaDir = await getApplicationDocumentsDirectory();
        String audioFilePath = '${mediaDir?.path}/downloaded_audio.mp3';
        String clippedAudioPath =
            '${mediaDir?.path}/podcasts/clipped_audio.mp3';

        // Ensure the directory exists
        await Directory('${mediaDir?.path}/podcasts').create(recursive: true);

        // Download the audio file if not already downloaded
        final response = await http.get(Uri.parse(audioUrl));
        if (response.statusCode == 200) {
          // Save the downloaded audio to a temporary path
          File audioFile = File(audioFilePath);
          await audioFile.writeAsBytes(response.bodyBytes);

          // Clip the audio using FFFmpeg
          String ffmpegCommand =
              '-i $audioFilePath -ss $startTime -t $clipDuration -c copy $clippedAudioPath';

          // Execute the FFFmpeg command
          final result = await FFmpegKit.execute(ffmpegCommand);
          final returnCode = await result.getReturnCode();

          if (ReturnCode.isSuccess(returnCode)) {
            print('Audio clipped successfully! Saved at: $clippedAudioPath');

            // Delete the downloaded audio file after clipping
            await audioFile.delete();
            print('Downloaded audio file deleted: $audioFilePath');
          } else {
            print('Error clipping audio: ${await result.getFailStackTrace()}');
          }
        } else {
          print('Failed to download audio: ${response.statusCode}');
        }
      } catch (e) {
        print('Error: $e');
      } finally {
        setState(() {
          _isClipping = false;
        });
      }
    } else {
      // Permission denied, handle accordingly
      print('Permission to access storage denied.');
    }
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
                ))
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
