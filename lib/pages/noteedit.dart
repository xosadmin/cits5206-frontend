import 'package:audiopin_frontend/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For JSON decoding
import 'homepage.dart';
import 'discover.dart';
import 'episode.dart';
import 'library.dart';
import 'setting.dart';

class NoteEditPage extends StatefulWidget  {
  @override
  _NoteEditPageState createState() => _NoteEditPageState();
}

class _NoteEditPageState extends State<NoteEditPage> {
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
          body: NoteEditBody(
            listtitle: args['listtitle'],
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

class NoteEditBody extends StatefulWidget {
  final String listtitle;

  NoteEditBody({
    required this.listtitle,
  });

  @override
  _NoteEditBodyState createState() => _NoteEditBodyState();
}

class _NoteEditBodyState extends State<NoteEditBody>{

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Title at the top-middle of the screen
          Padding(
            padding: const EdgeInsets.only(top: 40.0), // Space from top of the screen
            child: Text(
              widget.listtitle,
              style: TextStyle(
                fontSize: 20.0, // Font size of the title
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center, // Center text horizontally
            ),
          ),
          SizedBox(height: 30.0), // Space between title and card

          // Card in the middle with buttons at the bottom
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9, // 90% of the screen width
              height: 200.0, // Fixed height for the card
              child: Card(
                color: Colors.white,
                elevation: 4.0, // Add shadow to the card
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0), // Rounded corners
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Text content inside the card
                      Text(
                        noteContents,
                        style: TextStyle(fontSize: 12.0, color: Colors.black87),
                        textAlign: TextAlign.left,
                      ),

                      // Buttons at the bottom
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              // Handle share action
                            },
                            icon: Icon(Icons.share, size: 12.0),
                            label: Text('Share'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.grey,
                              side: BorderSide(color: Colors.grey),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.0), // Adjust the border radius here
                              ),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              // Handle comment action
                            },
                            icon: Icon(Icons.comment, size: 12.0),
                            label: Text('Comment'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.grey,
                              side: BorderSide(color: Colors.grey),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.0), // Adjust the border radius here
                              ),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              _showDeleteDialog(context);
                            },
                            icon: Icon(Icons.delete, size: 12.0),
                            label: Text('Delete'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.grey,
                              side: BorderSide(color: Colors.grey),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.0), // Adjust the border radius here
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          backgroundColor: Colors.white, // Set background color to white
          contentPadding: EdgeInsets.all(20.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.warning_amber_rounded,
                size: 60.0,
                color: Colors.grey,
              ),
              SizedBox(height: 20.0),
              Text(
                'You want to delete this recording',
                style: TextStyle(
                  fontSize: 14.0, // Set font size to 10
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.0),
              Text(
                'Are you sure you want to proceed?',
                style: TextStyle(
                  fontSize: 12.0, // Set font size to 10
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: 10.0, // Increase button height
                        horizontal: 22.0, // Increase button width
                      ),
                      side: BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0), // Set button border radius to 5
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(fontSize: 12.0, color: Colors.black), // Button text size
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Handle the delete action here
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(
                        vertical: 10.0, // Increase button height
                        horizontal: 22.0, // Increase button width
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0), // Set button border radius to 5
                      ),
                    ),
                    child: Text(
                      'Delete',
                      style: TextStyle(fontSize: 10.0, color: Colors.white), // Button text size
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }


}

Future<List<String>> getNotesDetails(String noteID) async {
  final url = Uri.parse('https://cits5206.7m7.moe/notedetails');
  List<String> res = [];

  // Define the payload for the POST request
  final payload = {
    'tokenID': "df09ecde-ca2e-47e5-b660-54d60ac35276",
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
      home: NoteEditPage(),
    ));
