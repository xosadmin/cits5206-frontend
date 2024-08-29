import 'package:audiopin_frontend/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For JSON decoding
import 'discover.dart';
import 'preview.dart';

class HomePage extends StatefulWidget  {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFFCFCFF),
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                  'assets/images/image1.jpg'),
            ),
          ),
          title: Text(
              "My Feed",
            style: TextStyle(
              fontFamily: 'EuclidCircularA',
              fontSize: 20,
            ),
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
        body: HomeBody(),
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

class HomeBody extends StatefulWidget {
  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody>{

  bool _isClickedPlay = false; // To track if the button is clicked
  List<String> noteIDs = [];

  @override
  void initState() {
    super.initState();
    getSubs(); // Fetch data when the widget is initialized
    getNotes();
    loadNotes();
    getNotesDetails(noteIDs);
  }

  void loadNotes() async {
    List<String> fetchedNoteIDs = await getNotes();
    setState(() {
      noteIDs = fetchedNoteIDs;
    });
    print('NoteIDs: $noteIDs');  // Debug: Print all NoteIDs
  }



  final List<String> imageUrls = [
    'assets/images/image1.jpg',
    'assets/images/image1.jpg',
    'assets/images/image1.jpg',
    'assets/images/image1.jpg',
    'assets/images/image1.jpg',
  ];

  final List<String> items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
    'Item 6',
  ];

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

  final List<String> listTime = [
    '12 mins Aug 22,2021',
    '45 mins Aug 19,2021',
    '1 h 30 mins Aug 19,2021',
    '38 mins Aug 22,2021',
    '2 mins Aug 19,2021',
    '1 h 17 mins Aug 20,2021',
  ];

  final List<String> listSubtitle = [
    "Short Stuff: Exploring Irish Monk",
    "#142 Natalie Morris",
    "Why Actors Never Actually Eat In Movies",
    "Glimmers of Grace (with Katie Butler)",
    "Comment la “sororité” est-elle née ?",
    "Testing one subtitle"
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Subscriptions section
        Container(
          width: MediaQuery.of(context).size.width * 0.92,
          margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.04),
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
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Subscriptions',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Subscription Cubes
                Container(
                  height: 64.0, // Height of the subscription cubes
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: imageUrls.length, // Number of subscription cubes
                    itemBuilder: (context, index) {
                      return Container(
                        width: 64.0, // Width of each cube
                        margin: EdgeInsets.symmetric(horizontal: 4.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.0), // Border radius for the container
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4.0),
                          child: Image.network(
                            imageUrls[index], // Load image from the URL
                            fit: BoxFit.cover, // Cover the entire cube
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 10.0),
              ],
            ),
          ),
        ),
        SizedBox(height: 15.0),
        Expanded(
          child: ListView.builder(
            itemCount: listImageUrls.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/preview',
                    arguments: {
                      'listtitle': listTitle[index],
                      'listimageurls': listImageUrls[index],
                      'listcontent': listContent[index],
                    },
                  );
                },
                child: Card(
                  color: Colors.white,
                  margin: EdgeInsets.all(16.0),
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
                                    listImageUrls[index],
                                    width: 35,
                                    height: 35,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(width: 16.0),
                                // Title and Time
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        listTitle[index],
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        listTime[index],
                                        style: TextStyle(
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
                              listSubtitle[index],
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              listContent[index],
                              style: TextStyle(
                                fontSize: 12.0,
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
                                print(listTitle[index]);
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
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}


Future<void> getSubs() async {
  final url = Uri.parse('https://cits5206.7m7.moe/listsubscription');

  // Define the payload for the POST request
  final payload = {
    'tokenID': "a65526ec-8f05-4e1e-b3ef-60b6854ae926",
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
    print('Response: ${response.body}');
  } else {}
}

Future<List<String>> getNotes() async {
  final url = Uri.parse('https://cits5206.7m7.moe/listnotes');

  final payload = {
    'tokenID': "a65526ec-8f05-4e1e-b3ef-60b6854ae926",
  };

  final headers = {
    'Content-Type': 'application/x-www-form-urlencoded',
  };

  final encodedPayload = payload.entries.map((entry) {
    return '${Uri.encodeComponent(entry.key)}=${Uri.encodeComponent(entry.value)}';
  }).join('&');

  final response = await http.post(
    url,
    headers: headers,
    body: encodedPayload,
  );

  if (response.statusCode == 200) {
    List<dynamic> notesList = jsonDecode(response.body);
    print(notesList);
    // Extract and return all NoteID values as a list of strings
    return notesList.map<String>((note) => note['NoteID'].toString()).toList();
  } else {
    return [];
  }
}

Future<List<String>> getNotesDetails(List<String> noteIDs) async {
  final url = Uri.parse('https://cits5206.7m7.moe/getnotedetails');
  List<String> contents = [];

  for (String noteID in noteIDs) {
    // Define the payload for the POST request
    final payload = {
      'tokenID': "a65526ec-8f05-4e1e-b3ef-60b6854ae926",
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

      // Assuming "Content" is the key for the content in the response
      if (noteDetails['Content'] != null) {
        contents.add(noteDetails['Content']);
      } else {
        print('Content not found for NoteID $noteID');
      }
    } else {
      print('Request failed for NoteID $noteID with status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  print(contents);
  return contents;
}





void main() =>
    runApp(MaterialApp(
      home: HomePage(),
    ));
