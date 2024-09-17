import 'package:audiopin_frontend/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For JSON decoding
import 'homepage.dart';
import 'discover.dart';
import 'episode.dart';

class PreviewPage extends StatefulWidget  {
  @override
  _PreviewPageState createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  int _selectedIndex = 0;

  static List<Widget> _pages = <Widget>[
    Center(child: Text('Feed Page')),
    Center(child: Text('Pins Page')),
    Center(child: Text('Discover Page')),
    Center(child: Text('Library Page')),
    Center(child: Text('Settings Page')),
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
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFFFCFCFF),
            leading: IconButton(
              icon: Icon(Icons.arrow_back), // Use Icons.arrow_back_ios for an iOS-style back button
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
                icon: Icon(Icons.notifications),
                onPressed: () {
                  print("Settings pressed");
                },
              ),
            ],
          ),
          backgroundColor: Color(0xFFFCFCFF),
          body: PreviewBody(
            listtitle: args['listtitle'],
            listimageurls: args['listimageurls'],
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
                }else if (index == 2){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DiscoverPage()),
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

class PreviewBody extends StatefulWidget {
  final String listtitle;
  final String listimageurls;

  PreviewBody({
    required this.listtitle,
    required this.listimageurls,
  });

  @override
  _PreviewBodyState createState() => _PreviewBodyState();
}

class _PreviewBodyState extends State<PreviewBody>{

  bool _isClickedPlay = false;
  String noteSubtitle = "testingSubtitle";
  String noteIDs = '';
  String noteDates = '';
  String notePodids = '';
  String noteContents = '';

  @override
  void initState() {
    super.initState();
    getNotesDetails(widget.listtitle);
    loadDatas();
  }

  void loadDatas() async {

    List<String> fetchedLists = await getNotesDetails(widget.listtitle);
    setState(() {
      noteIDs = fetchedLists[0];
      noteContents = fetchedLists[1];
      noteDates = fetchedLists[2];
      notePodids = fetchedLists[3];
    });
    print('$noteIDs $noteContents $noteDates $notePodids');
  }

  final List<String> listImageUrls = [
    'assets/images/image1.jpg',
    'assets/images/image1.jpg',
    'assets/images/image1.jpg',
    'assets/images/image1.jpg',
    'assets/images/image1.jpg',
  ];

  final List<String> listTitle = [
    'The lazy Genuis',
    'GriefCasts',
    'The Sporkful',
    'Think Biblically',
    'Choses a Savoir',
    'Slate Culture',
  ];

  final List<String> listContent = [
    'There’s a long-standing legend that an Irish monk was the first European to sail to America....',
    'This week I’m talking to writer + journalist Natalie Morris about her Dad, who died last summer....',
    'Does Ratatouille accurately portray restaurant critics? What’s the lamest food trope in cinema? ',
    'In her years of medical practice as a trauma surgeon, Dr. Katie Butler has seen it all, and also seen .....',
    'La "sororité" est apparue, dans les milieux féministes, en réaction à la notion de "fraternité", perçue a...',
    'Just for testing...',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 230.0, // Set the height of the cube
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: [
                BoxShadow(
                  color: Color(0x1A282626), // Shadow color with transparency
                  offset: Offset(0, 1), // Horizontal and vertical offsets
                  blurRadius: 4.0, // Blur radius
                  spreadRadius: 0.0, // Spread radius
                ),
              ],
            ),
            child: Stack(
              children: [
                // Title in the top left
                Positioned(
                  top: 8.0,
                  left: 8.0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0), // Add padding here
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Existing Text widgets
                        Text(
                          widget.listtitle,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          noteSubtitle,
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 4.0), // Optional: Add spacing between text and the row
                        // New Row with button and share icon
                        Row(
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                // Handle button press
                              },
                              icon: Icon(Icons.add, size: 16.0), // "+" icon
                              label: Text("Subscribe"), // "Subscribe" text
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                minimumSize: Size(90.0, 25.0),
                                side: BorderSide(
                                  color: Colors.grey, // Set the border color
                                  width: 0.7, // Set the border width (boldness)
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0), // Optional: Make the border rounded
                                ),
                              ),
                            ),
                            SizedBox(width: 16.0), // Space between button and share icon
                            IconButton(
                              icon: Icon(Icons.share, size: 16.0),
                              color: Colors.blue, // Icon color
                              onPressed: () {
                                // Handle share button press
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Image in the top right
                Positioned(
                  top: 8.0,
                  right: 8.0,
                  child: Container(
                    width: 76.0, // Width of each cube
                    height: 76.0,
                    margin: EdgeInsets.symmetric(horizontal: 4.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.0), // Border radius for the container
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4.0),
                      child: Image.network(
                        widget.listimageurls, // Load image from the URL
                        fit: BoxFit.cover, // Cover the entire cube
                      ),
                    ),
                  ),
                ),
                // Text in the middle body
                Positioned(
                  top: 110.0, // Adjust this position as necessary
                  left: 16.0,
                  right: 16.0,
                  child: Text(
                    noteContents,
                    style: TextStyle(
                      fontSize: 14.0,
                    ),
                    textAlign: TextAlign.left, // Center the text horizontally
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.0), // Space between the container and the column of cards
          Expanded(
            child: ListView.builder(
              itemCount: notePodids.length, // Number of cards
              itemBuilder: (context, index) {
                return InkWell(
                    onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/episode',
                    arguments: {
                      'listtitle': noteIDs,
                      'notepodid': notePodids,
                      'notedate': noteDates,
                      'notecontent': noteContents,
                    },
                  );
                },
                    child: Card(
                      color: Colors.white,
                      margin: EdgeInsets.symmetric(vertical: 8.0), // Space between cards
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title at the top
                            Text(
                              "# ${notePodids}", // Replace with your dynamic title
                              style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.black
                              ),
                            ),
                            SizedBox(height: 8.0),
                            // Subtitle in the middle
                            Text(
                              noteDates, // Replace with your dynamic subtitle
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 16.0),
                            // Button at the bottom
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: OverflowBar(
                                alignment: MainAxisAlignment.spaceBetween, // Enable horizontal scrolling if needed
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        _isClickedPlay = !_isClickedPlay; // Toggle the state on press
                                      });
                                      print(listTitle[index]);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      minimumSize: Size(60.0, 26.0),
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
                                          style: TextStyle(color: Colors.grey, fontSize: 10.0),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 8.0), // Add spacing between buttons
                                  ElevatedButton(
                                    onPressed: () {
                                      print('Add');
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      minimumSize: Size(100.0, 26.0),
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
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 8.0), // Add spacing between buttons
                                  ElevatedButton(
                                    onPressed: () {
                                      print('Download');
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      minimumSize: Size(90.0, 26.0),
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
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                );

              },
            ),
          ),
        ],
      ),
    );
  }
}

Future<List<String>> getNotesDetails(String noteID) async {
  final url = Uri.parse('https://cits5206.7m7.moe/notedetails');
  List<String> res = [];

  // Define the payload for the POST request
  final payload = {
    'tokenID': "0cd4cad2-efdb-49da-b49d-ef014a6b3223",
    'noteID': noteID,
  };

  // Set the headers to specify that the data is x-www-form-urlencoded
  final headers = {
    'Content-Type': 'application/x-www-form-urlencoded',
  };

  // Encode the payload as x-www-form-urlencoded
  final encodedPayload = payload.entries.map((entry) {
    return '${Uri.encodeComponent(entry.key)}=${Uri.encodeComponent(entry.value)}';
  }).join('&');

  // Send the POST request
  final response = await http.post(
    url,
    headers: headers,
    body: encodedPayload,
  );

  // Check the response status code
  if (response.statusCode == 200) {
      var noteDetails = jsonDecode(response.body);
      Map<String, dynamic> parsedResponse = jsonDecode(response.body);
      res.add(parsedResponse["NoteID"]);
      res.add(parsedResponse["Content"]);
      res.add(parsedResponse["DateCreated"]);
      res.add(parsedResponse["PodcastID"]);
    } else {}

  return res;
}

void main() =>
    runApp(MaterialApp(
      home: PreviewPage(),
    ));
