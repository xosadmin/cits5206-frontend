import 'package:flutter/material.dart';
// For JSON decoding
import 'homepage.dart';
import 'setting.dart';
import 'discover.dart';
import 'setting.dart';
import 'pins.dart';

class LibraryPage extends StatefulWidget  {
  const LibraryPage({super.key});

  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {

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
                    MaterialPageRoute(builder: (context) => SettingPage()),
                  );
                },
                child: const CircleAvatar(
                  backgroundImage: AssetImage('assets/images/image1.jpg'),
                ),
              ),
            ),

            title: const Text(
              "Library",
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
          body: LibraryBody(),
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

class LibraryBody extends StatefulWidget  {
  const LibraryBody({super.key});

  @override
  _LibraryBodyState createState() => _LibraryBodyState();
}


class _LibraryBodyState extends State<LibraryBody> {

  bool _isClickedPlay = false; // To track if the button is clicked
  String imageUrl = 'assets/images/note_exp.png';
  String noteContent = "Click to view details";

  List<String> libTits = [];
  List<String> libRsss = [];
  List<String> libDates = [];

  @override
  void initState() {
    super.initState();
    getLibrary();
    loadDatas();
  }


  void loadDatas() async {
    List<List<String>> fetchedLists = await getLibrary();
    setState(() {
      libTits = fetchedLists[0];;
      libRsss = fetchedLists[1];
      libDates = fetchedLists[2];
    });
    print('$libTits $libRsss $libDates');
  }


  final List<String> imageUrls = [
    'assets/images/note1.png',
    'assets/images/note2.png',
    'assets/images/note3.png',
    'assets/images/note4.png',
    'assets/images/note5.png',
  ];

  final List<String> cateText = [
    'Subscriptions',
    'Queue',
    'Downloads',
    'History',
    'Other'
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
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero, // Optional: Make the border rounded
                    ),
                  ),
                  child: Text(
                    cateText[index],
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 10.0,
                    ),
                  ),
                );
              }
          ),
        ),
        const SizedBox(height: 4.0),
        Container(
          width: MediaQuery.of(context).size.width * 0.92,
          margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.04),
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
        ),
        Expanded(
          child: ListView.builder(
            itemCount: libTits.length,
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
                              IconButton(
                                icon: const Icon(Icons.menu, size: 20),
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
                              const SizedBox(width: 16.0),
                              // Title and Time
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      libTits[index],
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      libDates[index],
                                      style: TextStyle(
                                        fontSize: 10.0,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    SizedBox(height: 10.0),
                                    Text(
                                      libRsss[index],
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        color: Colors.black,
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
                              minimumSize: const Size(67.0, 26.0),
                              side: const BorderSide(
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
                                  color: const Color(0xFF1D1DD1),
                                  size: 10.0,
                                ),
                                const SizedBox(width: 8.0),
                                const Text(
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
                              minimumSize: const Size(111.0, 26.0),
                              side: const BorderSide(
                                color: Colors.grey, // Set the border color
                                width: 0.7, // Set the border width (boldness)
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0), // Optional: Make the border rounded
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
                              minimumSize: const Size(104.0, 26.0),
                              side: const BorderSide(
                                color: Colors.grey, // Set the border color
                                width: 0.7, // Set the border width (boldness)
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0), // Optional: Make the border rounded
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
              backgroundColor: Colors.white,
              elevation: 0,
              child: Image.network(
                'assets/images/audio.png', // Replace with your image path
                width: 50, // Adjust size as needed
                height: 50,
              ), // Optional: Remove shadow if needed
            ),
          ),
        ),

      ],
    );
  }
}

Future <String> getTokenId() async{
  final url = Uri.parse('https://cits5206.7m7.moe/login');

  // Define the payload for the POST request
  final payload = {
    'username': "admin",
    'password': "admin"
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
  return json.decode(response.body)['Token'];
}


Future<List<List<String>>> getLibrary() async {
  String tokenid = await getTokenId();

  final url = Uri.parse('https://cits5206.7m7.moe/listsubscription');

  final payload = {
    'tokenID': tokenid,
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
    List<String> tit = notesList.map<String>((note) => note['Title'].toString()).toList();
    List<String> rss = notesList.map<String>((note) => note['rssUrl'].toString()).toList();
    List<String> date = notesList.map<String>((note) => note['Date'].toString()).toList();
    //return getNotesDetails(res);
    return [tit, rss, date];
  } else {
    return [];
  }
}


void main() =>
    runApp(MaterialApp(
      home: LibraryPage(),
    ));
