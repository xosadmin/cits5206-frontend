import 'package:flutter/material.dart';
import 'discover.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: NetworkImage('assets/images/image1.jpg'),
          ),
        ),
        title: const Text(
          "My Feed",
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
      body: const HomeBody(),
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
            } else {
              _onItemTapped(index);
            }
          }),
    ));
  }
}

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  bool _isClickedPlay = false; // To track if the button is clicked

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
                    'Subscriptions',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Subscription Cubes
                SizedBox(
                  height: 64.0, // Height of the subscription cubes
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: imageUrls.length, // Number of subscription cubes
                    itemBuilder: (context, index) {
                      return Container(
                        width: 64.0, // Width of each cube
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                              4.0), // Border radius for the container
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
                const SizedBox(height: 10.0),
              ],
            ),
          ),
        ),
        const SizedBox(height: 15.0),
        Expanded(
          child: ListView.builder(
            itemCount: listImageUrls.length,
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
                                      listTitle[index],
                                      style: const TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      listTime[index],
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
                            listSubtitle[index],
                            style: const TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            listContent[index],
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

void main() => runApp(const MaterialApp(
      home: HomePage(),
    ));
