import 'package:audiopin_frontend/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For JSON decoding
import 'homepage.dart';
import 'setting.dart';
import 'discover.dart';

class LibraryPage extends StatefulWidget  {
  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {

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
              child: GestureDetector(
                onTap: () {
                  // Navigate to the settings page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingPage()),
                  );
                },
                child: CircleAvatar(
                  backgroundImage: AssetImage('assets/images/image1.jpg'),
                ),
              ),
            ),

            title: Text(
              "Library",
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
          body: LibraryBody(),
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

class LibraryBody extends StatefulWidget  {
  @override
  _LibraryBodyState createState() => _LibraryBodyState();
}


class _LibraryBodyState extends State<LibraryBody> {

  bool _isClickedPlay = false; // To track if the button is clicked
  List<bool> _isSelectedCate  = [];
  String imageUrl = 'assets/images/note_exp.png';
  String noteContent = "Click to view details";

  final List<String> imageUrls = [
    'assets/images/note1.png',
    'assets/images/note2.png',
    'assets/images/note3.png',
    'assets/images/note4.png',
    'assets/images/note5.png',
  ];

  final List<String> cateText = [
    'For you',
    'News',
    'Culture',
    'Cryptocurrency',
    'Education',
  ];

  final List<String> imageText = [
    'The lazy Genuis',
    'GriefCasts',
    'The Sporkful',
    'Think Biblically',
    'Choses a Savoir',
    'Slate Culture',
  ];

  final List<String> imageText2 = [
    'NBC Radio',
    'GriefCasts',
    'New York Times',
    'Song Explorer',
    'Choses',
    'Fat',
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
    'assets/images/note1.png',
    'assets/images/note2.png',
    'assets/images/note3.png',
    'assets/images/note4.png',
    'assets/images/note5.png',
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
    return Stack(
      children: [
      Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 20.0, // Increased height to accommodate text below the cubes
          width: MediaQuery.of(context).size.width * 0.9,
          margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05, top: 20),
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: imageUrls.length,
              itemBuilder: (context, index){
                return ElevatedButton(
                  onPressed: () {
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side:BorderSide.none,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero, // Optional: Make the border rounded
                    ),
                  ),
                  child: Text(
                    cateText[index],
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 10.0,
                    ),
                  ),
                );
              }
          ),
        ),
        SizedBox(height: 4.0),
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
        ),
        Expanded(
          child: ListView.builder(
            itemCount: listImageUrls.length,
            itemBuilder: (context, index) {
              return Card(
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
                              IconButton(
                                icon: Icon(Icons.menu, size: 20),
                                onPressed: () {
                                  // Handle menu press
                                  print('Menu pressed');
                                },
                              ),
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
              );
            },
          ),
        ),
      ],
    ),
        Positioned(
          height: 50,
          width: 50,
          bottom: 15.0, // Adjust how far from the bottom of the screen
          right: 15.0, // Adjust how far from the right of the screen
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50.0), // Set custom border radius
            child: FloatingActionButton(
              onPressed: () {
                print('Floating Action Button pressed');
              },
              child: Image.asset(
                'assets/images/audio.png', // Replace with your image path
                width: 50, // Adjust size as needed
                height: 50,
              ),
              backgroundColor: Colors.white,
              elevation: 0, // Optional: Remove shadow if needed
            ),
          ),
        ),

      ],
    );
  }
}

void main() =>
    runApp(MaterialApp(
      home: LibraryPage(),
    ));
