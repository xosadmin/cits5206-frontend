import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For JSON decoding
import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'homepage.dart';
import 'discover.dart';
import 'library.dart';
import 'setting.dart';
import 'pins.dart';

class EpisodePage extends StatefulWidget {
  const EpisodePage({super.key});

  @override
  _EpisodePageState createState() => _EpisodePageState();
}

class _EpisodePageState extends State<EpisodePage> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    const Center(child: Text('Feed Page')),
    const Center(child: Text('Pins Page')),
    const Center(child: Text('Discover Page')),
    const Center(child: Text('Library Page')),
    const Center(child: Text('Settings Page')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Method to build the body of the Scaffold
  Widget _buildBody() {
    return _pages[_selectedIndex];
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFCFCFF),
        leading: IconButton(
          icon: const Icon(Icons
              .arrow_back), // Use Icons.arrow_back_ios for an iOS-style back button
          onPressed: () {
            Navigator.pop(
              context,
              MaterialPageRoute(
                builder: (context) => HomeBody(),
              ),
            ); // Navigate back to the previous screen
          },
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              print("Settings pressed");
            },
          ),
          backgroundColor: Color(0xFFFCFCFF),
          body: EpisodeBody(
            listtitle: args['listtitle'],
            notepodid: args['notepodid'],
            notedate: args['notedate'],
            notecontent: args['notecontent'],
          ),
          bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Color(0xFFFCFCFF),
              type: BottomNavigationBarType.fixed,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Feed',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.note),
                  label: 'Pins',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: 'Discover',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.collections),
                  label: 'Library',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: 'Settings',
                ),
              ],
              currentIndex: _selectedIndex, // Current selected index
              selectedItemColor: Colors.blue, // Color of the selected item
              onTap: (index){
                if (index == 0){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                }else if (index == 1){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PinsPage()),
                  );
                }else if (index == 2){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DiscoverPage()),
                  );
                }else if (index == 3){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LibraryPage()),
                  );
                }else if (index == 4){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingPage()),
                  );
                }else{
                  _onItemTapped(index);
                }
              }
          ),
        )
    );
  }
}

class EpisodeBody extends StatefulWidget {
  final String listtitle;
  final String notepodid;
  final String notedate;
  final String notecontent;

  const EpisodeBody({
    super.key,
    required this.listtitle,
    required this.notepodid,
    required this.notedate,
    required this.notecontent,
  });

  @override
  _EpisodeBodyState createState() => _EpisodeBodyState();
}

class _EpisodeBodyState extends State<EpisodeBody> {
  String imageUrl = 'assets/images/note_exp.png';
  bool _isClickedPlay = false; // To track if the button is clicked
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _showPlayer = false;
  String _audioUrl = 'assets/audio/episode.mp3';
  double _currentPosition = 0.0;
  double _totalDuration = 0.0;

  // Play/Pause function
  void _playMusic() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
      setState(() {
        _isPlaying = false;
      });
    } else {
      await _audioPlayer.play(UrlSource(_audioUrl));

      // Update the total duration of the audio
      _audioPlayer.onDurationChanged.listen((Duration duration) {
        setState(() {
          _totalDuration =
              duration.inSeconds.toDouble(); // Set the total duration
        });
      });

      // Update the current position of the audio
      _audioPlayer.onPositionChanged.listen((Duration position) {
        setState(() {
          _currentPosition =
              position.inSeconds.toDouble(); // Update the current position
        });
      });

      setState(() {
        _isPlaying = true;
      });
    }
  }

  void _showAudioPlayer() {
    setState(() {
      _showPlayer = true;
    });
  }

  @override
  void dispose() {
    _audioPlayer
        .dispose(); // Dispose of the audio player when the widget is destroyed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 170.0,
            child: ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.white,
                  margin: const EdgeInsets.all(16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top part of the card: Image and title/time
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Image
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(5.0),
                                  child: Image.network(
                                    imageUrl,
                                    width: 35,
                                    height: 35,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 16.0),
                                // Title and Time
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.listtitle,
                                        style: const TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        widget.notedate,
                                        style: const TextStyle(
                                          fontSize: 12.0,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Middle part of the card: Content
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "# ${widget.notepodid}",
                              style: const TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Bottom part of the card: Buttons
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: OverflowBar(
                          alignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _isClickedPlay =
                                      !_isClickedPlay; // Toggle the state on press
                                });
                                _showAudioPlayer(); // Show the audio player
                                _playMusic(); // Start playing music
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                minimumSize: const Size(67.0, 26.0),
                                side: const BorderSide(
                                  color: Colors.grey, // Set the border color
                                  width: 0.7, // Set the border width (boldness)
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      5.0), // Optional: Make the border rounded
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    _isClickedPlay
                                        ? Icons.check
                                        : Icons.play_circle,
                                    color: const Color(0xFF1D1DD1),
                                    size: 10.0,
                                  ),
                                  const SizedBox(width: 8.0),
                                  const Text(
                                    'Play',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 10.0),
                                  )
                                ],
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                print('Add');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                minimumSize: const Size(111.0, 26.0),
                                side: const BorderSide(
                                  color: Colors.grey, // Set the border color
                                  width: 0.7, // Set the border width (boldness)
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      5.0), // Optional: Make the border rounded
                                ),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.add,
                                    color: Color(0xFF1D1DD1),
                                    size: 10.0,
                                  ),
                                  SizedBox(width: 8.0),
                                  Text(
                                    'Add to queue',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 10.0),
                                  )
                                ],
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                print('Download');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                minimumSize: const Size(104.0, 26.0),
                                side: const BorderSide(
                                  color: Colors.grey, // Set the border color
                                  width: 0.7, // Set the border width (boldness)
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      5.0), // Optional: Make the border rounded
                                ),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.download,
                                    color: Color(0xFF1D1DD1),
                                    size: 10.0,
                                  ),
                                  SizedBox(width: 8.0),
                                  Text(
                                    'Download',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 10.0),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        // Middle part of the card: Content
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "# ${widget.notepodid}",
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Bottom part of the card: Buttons
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: OverflowBar(
                            alignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _isClickedPlay = !_isClickedPlay; // Toggle the state on press
                                  });
                                  _showAudioPlayer(); // Show the audio player
                                  _playMusic(); // Start playing music
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  minimumSize: Size(67.0, 26.0),
                                  side: BorderSide(
                                    color: Colors.grey, // Set the border color
                                    width: 0.7, // Set the border width (boldness)
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0), // Optional: Make the border rounded
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      _isClickedPlay ? Icons.check : Icons.play_circle,
                                      color: Color(0xFF1D1DD1),
                                      size: 10.0,
                                    ),
                                    SizedBox(width: 8.0),
                                    Text(
                                      'Play',
                                      style: TextStyle(color:Colors.grey, fontSize: 10.0),
                                    )
                                  ],
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  print('Add');
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  minimumSize: Size(111.0, 26.0),
                                  side: BorderSide(
                                    color: Colors.grey, // Set the border color
                                    width: 0.7, // Set the border width (boldness)
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0), // Optional: Make the border rounded
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.add,
                                      color: Color(0xFF1D1DD1),
                                      size: 10.0,
                                    ),
                                    SizedBox(width: 8.0),
                                    Text(
                                      'Add to queue',
                                      style: TextStyle(color: Colors.grey, fontSize: 10.0),
                                    )
                                  ],
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  print('Download');
                                  String url = 'assets/audio/episode.mp3'; // MP3 file URL
                                  downloadFile(url, "podcast.mp3");
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  minimumSize: Size(104.0, 26.0),
                                  side: BorderSide(
                                    color: Colors.grey, // Set the border color
                                    width: 0.7, // Set the border width (boldness)
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0), // Optional: Make the border rounded
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.download,
                                      color: Color(0xFF1D1DD1),
                                      size: 10.0,
                                    ),
                                    SizedBox(width: 8.0),
                                    Text(
                                      'Download',
                                      style: TextStyle(color: Colors.grey, fontSize: 10.0),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
              },
            ),
          ),
          Container(
            height:
                400.0, // Set the height of the container to the screen height
            width: MediaQuery.of(context).size.width * 0.92,
            margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.04),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1A282626), // Shadow color with transparency
                  offset: Offset(0, 1), // Horizontal and vertical offsets
                  blurRadius: 4.0, // Blur radius
                  spreadRadius: 0.0, // Spread radius
                ),
              ],
            ),
            child: Text(
              widget.notecontent, // Content to display inside the container
              style: const TextStyle(
                fontSize: 14.0, // Text size
                color: Colors.grey, // Text color
              ),
            ),
          ),
          if (_showPlayer)
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Image on the left
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5.0),
                        child: Image.network(
                          imageUrl, // Replace with your image URL
                          width: 35,
                          height: 35,
                          fit: BoxFit.cover,
                        ),
                      ),

                      const SizedBox(
                          width: 16.0), // Space between image and text

                      // Middle section with title and slider
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Title
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 22.0), // Add 10.0 padding to the left
                              child: Text(
                                widget.listtitle,
                                style: const TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),

                            // Slider (show only if _totalDuration is greater than 0)
                            if (_totalDuration > 0)
                              SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  activeTrackColor: Colors
                                      .blue, // Color of the active part of the slider
                                  inactiveTrackColor: Colors
                                      .grey, // Color of the inactive part of the slider
                                  trackHeight:
                                      2.0, // Height of the slider track
                                  thumbShape: SliderComponentShape.noThumb,
                                ),
                                child: Slider(
                                  value:
                                      _currentPosition, // Current position of the slider
                                  min: 0.0,
                                  max:
                                      _totalDuration, // Total duration of the audio
                                  onChanged: (newValue) {
                                    setState(() {
                                      _currentPosition = newValue;
                                    });
                                    _audioPlayer.seek(
                                        Duration(seconds: newValue.toInt()));
                                  },
                                ),
                              )
                          ],
                        ),
                      ),

                      // Play/Pause button on the right
                      IconButton(
                        icon: Icon(
                          _isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Colors.grey,
                          size: 25.0,
                        ),
                        onPressed: _playMusic,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}


// Simple download function
Future<void> downloadFile(String url, String fileName) async {
  try {
    Dio dio = Dio();

    // Get the local storage directory
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String savePath = "${appDocDir.path}/$fileName";

    // Download the file without progress or completion handling
    await dio.download(url, savePath);
    print("File downloaded to $savePath");
  } catch (e) {
    print("Download failed: $e");
  }
}



void main() =>
    runApp(MaterialApp(
      home: EpisodePage(),
    ));
