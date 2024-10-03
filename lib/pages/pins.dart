import 'package:audiopin_frontend/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For JSON decoding
import 'homepage.dart';
import 'setting.dart';
import 'discover.dart';
import 'setting.dart';
import 'library.dart';

class PinsPage extends StatefulWidget  {
  @override
  _PinsPageState createState() => _PinsPageState();
}

class _PinsPageState extends State<PinsPage> {

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
            leading: IconButton(
              icon: Icon(Icons.cloud_upload), // Use Icons.arrow_back_ios for an iOS-style back button
              onPressed: () {
                // Navigate back to the previous screen
              },
            ),

            title: Text(
              "Note",
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
          body: PinsBody(),
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

class PinsBody extends StatefulWidget  {
  @override
  _PinsBodyState createState() => _PinsBodyState();
}


class _PinsBodyState extends State<PinsBody> {

  List<String> noteIDs = [];
  List<String> noteDates = [];
  List<String> notePodids = [];

  @override
  void initState() {
    super.initState();
    getSubs(); // Fetch data when the widget is initialized
    getNotes();
    loadDatas();
  }


  void loadDatas() async {;
    List<List<String>> fetchedLists = await getNotes();
    setState(() {
      noteIDs = fetchedLists[0];;
      notePodids = fetchedLists[1];
      noteDates = fetchedLists[2];
    });
    print('$noteIDs $noteDates $notePodids');
  }

  final List<Map<String, String>> cardsData = [
    {
      "date": "25 Aug, 2021",
      "title": "Why Actors Never Actually Eat In Movies",
      "content": "Earth is the third planet from the Sun and the only astronomical object known to harbor life...",
    },
    {
      "date": "18 Aug, 2021",
      "title": "#229 - How to Magic Question the Rest of 2021",
      "content": "Find yourself in the middle of day 52 wondering how in the world you're going to make it...",
    },
    {
      "date": "30 July, 2021",
      "title": "Short Stuff: Exploring Irish Monk",
      "content": "There are only 95 days between today and December 31st...",
    },
    {
      "date": "18 Aug, 2021",
      "title": "Episode #80 I Got Covid-19 And Other Short Stories",
      "content": "I got Covid-19 and by God’s grace Survived...",
    },
    {
      "date": "18 Aug, 2021",
      "title": "#Episode 83 Learning My 'Enough' Feat. Kevin Mwachi",
      "content": "#Episode 83 Learning My 'Enough' Feat. Kevin Mwachi...",
    },
    {
      "date": "18 Aug, 2021",
      "title": "#142 Natalie Morris",
      "content": "Alios autem dicere aliut...",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          height: 48.0, // Increased height for better visibility
          decoration: BoxDecoration(
            color: Colors.white, // Background color of the search bar
            borderRadius: BorderRadius.circular(8.0), // Rounded corners
            border: Border.all(color: Colors.grey), // Border color
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3), // Shadow position
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(Icons.search, color: Colors.grey, size: 20.0), // Adjusted icon size
              SizedBox(width: 8.0), // Space between the icon and the text
              Expanded(
                child: TextField(
                  style: TextStyle(
                    fontSize: 14.0, // Adjusted font size for better readability
                  ),
                  decoration: InputDecoration(
                    hintText: "Search for note2", // Placeholder text
                    border: InputBorder.none, // Remove the default border
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0), // Adjust vertical padding
                  ),
                  onChanged: (value) {
                    // Handle search input changes here
                    print("Search query: $value");
                  },
                ),
              ),
            ],
          ),
        ),
        // Titles Row: Notes (Left) and Achieved (Right)
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0), // Adjust the horizontal padding as needed
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align titles to opposite sides
            children: [
              Text(
                'Notes', // Title on the left
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Achieved', // Title on the right
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        // Grid View for Cards
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Two cards per row
                mainAxisSpacing: 16.0, // Spacing between rows
                crossAxisSpacing: 16.0, // Spacing between columns
                childAspectRatio: 0.75, // Adjust this ratio to control card height
              ),
              itemCount: noteDates.length, // Number of cards
              itemBuilder: (context, index) {
                return InkWell(
                    onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/noteedit',
                    arguments: {
                      'listtitle': noteIDs[index],
                    },
                  );
                },
                child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 4.0, // Add shadow for the card
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          noteDates[index],
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          noteIDs[index],
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Expanded(
                          child: Text(
                            cardsData[index]["content"]!,
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis, // Add ellipsis for overflowing text
                            maxLines: 4, // Limit the number of lines for the content
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
        ),

      ],
    );
  }
}

Future<List<List<String>>> getNotes() async {
  final url = Uri.parse('https://cits5206.7m7.moe/listnotes');

  final payload = {
    'tokenID': "df09ecde-ca2e-47e5-b660-54d60ac35276",
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
    // Extract and return all NoteID values as a list of strings
    List<String> id = notesList.map<String>((note) => note['NoteID'].toString()).toList();
    List<String> pod = notesList.map<String>((note) => note['PodcastID'].toString()).toList();
    List<String> date = notesList.map<String>((note) => note['DateCreated'].toString()).toList();
    //return getNotesDetails(res);
    return [id, pod, date];
  } else {
    return [];
  }
}


void main() =>
    runApp(MaterialApp(
      home: PinsPage(),
    ));