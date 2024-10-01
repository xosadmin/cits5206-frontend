import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For JSON decoding
import 'homepage.dart';
import 'setting.dart';
import 'library.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  _DiscoverPageState createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
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
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFCFCFF),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              // Navigate to the settings page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingPage()),
              );
            },
            child: const CircleAvatar(
              backgroundImage: AssetImage('assets/images/image1.jpg'),
            ),
          ),
        ),
        title: const Text(
          "Explore",
          style: TextStyle(
            fontFamily: 'EuclidCircularA',
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              print("Settings pressed");
            },
          ),
        ],
      ),
      backgroundColor: const Color(0xFFFCFCFF),
      body: const DiscoverBody(),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color(0xFFFCFCFF),
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
          onTap: (index) {
            if (index == 0) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            } else if (index == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DiscoverPage()),
              );
            } else if (index == 3) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LibraryPage()),
              );
            } else if (index == 4) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingPage()),
              );
            } else {
              _onItemTapped(index);
            }
          }),
    ));
  }
}

class DiscoverBody extends StatefulWidget {
  const DiscoverBody({super.key});

  @override
  _DiscoverBodyState createState() => _DiscoverBodyState();
}

class _DiscoverBodyState extends State<DiscoverBody> {
  bool _isClickedPlay = false; // To track if the button is clicked
  List<bool> _isSelectedCate = [];
  String imageUrl = 'assets/images/note_exp.png';
  String noteContent = "Click to view details";
  List<String> subs = [];
  List<String> noteIDs = [];
  List<String> noteDates = [];
  List<String> notePodids = [];

  @override
  void initState() {
    super.initState();
    // Initialize the list with false values indicating no button is selected initially
    _isSelectedCate = List.generate(imageUrls.length, (index) => false);
    getNotes();
    loadDatas();
  }

  void loadDatas() async {
    List<List<String>> fetchedLists = await getNotes();
    setState(() {
      noteIDs = fetchedLists[0];
      notePodids = fetchedLists[1];
      noteDates = fetchedLists[2];
    });
    print('$noteIDs $noteDates $notePodids');
  }

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
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          height: 34.0,
          decoration: BoxDecoration(
            color: Colors.white, // Background color of the search bar
            borderRadius: BorderRadius.circular(3.0), // Rounded corners
            border: Border.all(color: Colors.grey), // Border color
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3), // Shadow position
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.search, color: Colors.grey, size: 14.0),
              const SizedBox(width: 8.0), // Space between the icon and the text
              Expanded(
                child: TextField(
                  style: const TextStyle(
                    fontSize: 12.0, // Adjusted font size
                  ),
                  decoration: const InputDecoration(
                    hintText: "Search for podcasts", // Placeholder text
                    border: InputBorder.none, // Remove the default border
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 14.0), // Adjust vertical padding
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
        Container(
          height: 20.0, // Increased height to accommodate text below the cubes
          width: MediaQuery.of(context).size.width * 0.9,
          margin:
              EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05),
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: imageUrls.length,
              itemBuilder: (context, index) {
                return ElevatedButton(
                  onPressed: () {
                    setState(() {
                      // Update the selected state for the button
                      _isSelectedCate =
                          List.generate(imageUrls.length, (i) => i == index);
                    });
                    print(index + 1);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isSelectedCate[index]
                        ? const Color(0xFF1D1DD1)
                        : Colors.white,
                    side: BorderSide.none,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius
                          .zero, // Optional: Make the border rounded
                    ),
                  ),
                  child: Text(
                    cateText[index],
                    style: TextStyle(
                      color:
                          _isSelectedCate[index] ? Colors.white : Colors.black,
                      fontSize: 10.0,
                    ),
                  ),
                );
              }),
        ),
        const SizedBox(height: 4.0),
        Container(
          width: MediaQuery.of(context).size.width * 0.92,
          margin:
              EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.04),
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
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Trending',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Trending Cubes
                SizedBox(
                  height: 140.0, // Height of the subscription cubes
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: imageUrls.length, // Number of subscription cubes
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment
                            .center, // Center text and image horizontally
                        children: [
                          Container(
                            width: 64.0, // Width of each cube
                            height: 64.0, // Height of each cube
                            margin: const EdgeInsets.symmetric(horizontal: 8.0),
                            color: Colors.white,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5.0),
                              child: Image.network(
                                imageUrls[index], // Load image from the URL
                                fit: BoxFit.cover, // Cover the entire cube
                              ),
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          SizedBox(
                            width: 64.0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  imageText[index], // Existing text
                                  softWrap: true,
                                  style: const TextStyle(
                                    fontSize: 12.0,
                                  ),
                                ),
                                const SizedBox(
                                    height:
                                        4.0), // Adds space between the texts
                                Text(
                                  imageText2[index], // New small text
                                  style: const TextStyle(
                                    fontSize:
                                        10.0, // Smaller font size for the new text
                                    color: Colors
                                        .black, // Optional: Adjust color if needed
                                  ),
                                ),
                              ],
                            ),
                          ), // Add spacing between the cube and the text
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10.0),
              ],
            ),
          ),
        ),
        const SizedBox(height: 15.0),
        Expanded(
          child: ListView.builder(
            itemCount: noteIDs.length,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      noteIDs[index],
                                      style: const TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      noteDates[index],
                                      style: const TextStyle(
                                        fontSize: 12.0,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                right: 0,
                                top: 0,
                                child: IconButton(
                                  icon: const Icon(Icons.more_vert),
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return const BottomOptions();
                                      },
                                    );
                                  },
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
                            "# ${notePodids[index]}",
                            style: const TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            noteContent,
                            style: const TextStyle(
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
                                _isClickedPlay =
                                    !_isClickedPlay; // Toggle the state on press
                              });
                              print(listTitle[index]);
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
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class BottomOptions extends StatelessWidget {
  const BottomOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize
            .min, // Makes the column take up the minimal vertical space
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.block),
            title: const Text('Block show from recommendation'),
            onTap: () {
              // Add your action here
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.thumb_up),
            title: const Text('Show more of shows like this'),
            onTap: () {
              // Add your action here
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.thumb_down),
            title: const Text('Show less of shows like this'),
            onTap: () {
              // Add your action here
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

Future<List<List<String>>> getNotes() async {
  final url = Uri.parse('https://cits5206.7m7.moe/listnotes');

  final payload = {
    'tokenID': "aab4f122-4dff-4eb3-ba24-d366619a63b5",
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
    List<String> id =
        notesList.map<String>((note) => note['NoteID'].toString()).toList();
    List<String> pod =
        notesList.map<String>((note) => note['PodcastID'].toString()).toList();
    List<String> date = notesList
        .map<String>((note) => note['DateCreated'].toString())
        .toList();
    //return getNotesDetails(res);
    return [id, pod, date];
  } else {
    return [];
  }
}

void main() => runApp(const MaterialApp(
      home: DiscoverPage(),
    ));
