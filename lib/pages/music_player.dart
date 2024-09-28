import 'package:flutter/material.dart';
import 'dart:async'; // For Timer
import 'dart:io'; // For exit() method
import 'package:share_plus/share_plus.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:flutter_cache_manager/flutter_cache_manager.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
// import 'package:ffmpeg_kit_flutter/return_code.dart';
// import 'package:bottom_picker/bottom_picker.dart';
// import 'dart:async';

class MusicPlayerPage extends StatefulWidget {
  final VoidCallback toggleTheme;

  const MusicPlayerPage({super.key, required this.toggleTheme});

  @override
  State<MusicPlayerPage> createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage> {
  Timer? _timer;
  bool isTimerSet = false;
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
        duration: Duration(seconds: 3),
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
        SnackBar(
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
      shape: RoundedRectangleBorder(
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
                SizedBox(height: 20),
                Text(
                  'Set Custom Time',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Hours Input Field
                    SizedBox(
                      width: 80,
                      child: TextFormField(
                        controller: hoursController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Hours',
                          border: OutlineInputBorder(),
                        ),
                        textAlign: TextAlign.center,
                        onTap: () {
                          // Adjust the modal when input is focused
                        },
                      ),
                    ),
                    SizedBox(width: 20),
                    // Colon separator
                    Text(
                      ':',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 20),
                    // Minutes Input Field
                    SizedBox(
                      width: 80,
                      child: TextFormField(
                        controller: minutesController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
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
                SizedBox(height: 20),
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
                        side: BorderSide(color: Colors.grey),
                      ),
                      child: Text(
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
                      child: Text(
                        'Set',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero, // No border radius as per the design
      ),
      builder: (BuildContext context) {
        return Container(
          height: 400,
          child: Column(
            children: [
              ListTile(
                title: Text('Off'),
                onTap: () {
                  _cancelTimer(); // Cancel any active timer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('15 Minutes'),
                onTap: () {
                  _scheduleAppClose(15); // Close in 15 minutes
                  Navigator.pop(context); // Close the bottom sheet
                },
              ),
              ListTile(
                title: Text('30 Minutes'),
                onTap: () {
                  _scheduleAppClose(30); // Close in 30 minutes
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('45 Minutes'),
                onTap: () {
                  _scheduleAppClose(45); // Close in 30 minutes
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('60 Minutes'),
                onTap: () {
                  _scheduleAppClose(60); // Close in 60 minutes
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Custom Time'),
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero, // No border radius
      ),
      builder: (BuildContext context) {
        // Get the current theme's background color
        Color? backgroundColor = Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[900] // Dark mode color
            : Colors.grey[200]; // Light mode color

        return Container(
          color: backgroundColor,  // Set background based on theme
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.thumb_up, color: Theme.of(context).iconTheme.color),
                title: Text(
                  'Show more of shows like this',
                 // Adapt text color to theme
                ),
                onTap: () {
                  // Handle action
                },
              ),
              ListTile(
                leading: Icon(Icons.thumb_down, color: Theme.of(context).iconTheme.color),
                title: Text(
                  'Show less of shows like this',
                    // Adapt text color to theme
                ),
                onTap: () {
                  // Handle action
                },
              ),
              ListTile(
                leading: Icon(Icons.file_download, color: Theme.of(context).iconTheme.color),
                title: Text(
                  'Download episode', // Adapt text color to theme
                ),
                onTap: () {
                  // Handle action
                },
              ),
              ListTile(
                leading: Icon(Icons.share, color: Theme.of(context).iconTheme.color),
                title: Text(
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

  void _shareEpisode() {
    // Sample text or URL to share
    final String episodeLink = 'https://example.com/podcast/episode/229';
    Share.share('Check out this podcast episode: $episodeLink');
  }

  @override
  void dispose() {
    // Cancel the timer if the widget is disposed to prevent memory leaks
    _timer?.cancel();
    super.dispose();
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
        body: const Column(
          key: Key('music_player_body'),
        ));
  }
}
