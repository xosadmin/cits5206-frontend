import 'package:audiopin_frontend/main.dart';
import 'package:flutter/material.dart';
import 'homepage.dart';

class DiscoverPage extends StatefulWidget  {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<DiscoverPage> {

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
            title: Text('Explore'),
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
          body: DiscoverBody(),
          bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Color(0xFFFCFCFF),
              type: BottomNavigationBarType.fixed,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Feed',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.book),
                  label: 'Pins',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: 'Discover',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.file_copy_outlined),
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




class DiscoverBody extends StatelessWidget {

  final List<String> imageUrls = [
    'assets/images/image1.jpg',
    'assets/images/image1.jpg',
    'assets/images/image1.jpg',
    'assets/images/image1.jpg',
    'assets/images/image1.jpg',
  ];

  final List<String> imageTxt = [
    'tend 1',
    'tend 2',
    'tend 3',
    'tend 4',
    'tend 5',
  ];

  final List<String> cateText = [
    'cate 1',
    'cate 2',
    'cate 3',
    'cate 4',
    'cate 5',
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
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
    'Item 6',
  ];

  final List<String> listTime = [
    'Time 1',
    'Time 2',
    'Time 3',
    'Time 4',
    'Time 5',
    'Time 6',
  ];

  final List<String> listContent = [
    'Content 1',
    'Content 2',
    'Content 3',
    'Content 4',
    'Content 5',
    'Content 6',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          height: 30.0,
          decoration: BoxDecoration(
            color: Colors.white, // Background color of the search bar
            borderRadius: BorderRadius.circular(10.0), // Rounded corners
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3), // Shadow position
              ),
            ],
          ),
          child: TextField(
            style: TextStyle(
              fontSize: 20.0
            ),
            decoration: InputDecoration(
              hintText: "Search...", // Placeholder text
              border: InputBorder.none, // Remove the default border
              icon: Icon(Icons.search, color: Colors.grey), // Search icon
            ),
            onChanged: (value) {
              // Handle search input changes here
              print("Search query: $value");
            },
          ),
        ),
        Container(
          height: 30.0, // Increased height to accommodate text below the cubes
          width: MediaQuery.of(context).size.width * 0.9,
          margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05),
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: imageUrls.length,
              itemBuilder: (context, index){
                return ElevatedButton(
                  onPressed: (){ print(index + 1);},
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
                          color: Colors.grey,
                          fontSize: 15.0,
                      ),
                  ),
                );
              }
           ),
        ),
        // Subscriptions section
        Container(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Trending',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          height: 150.0, // Increased height to accommodate text below the cubes
          width: MediaQuery.of(context).size.width * 0.9,
          margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: imageUrls.length, // Number of subscription cubes
            itemBuilder: (context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center, // Center text and image horizontally
                children: [
                  Container(
                    width: 100.0, // Width of each cube
                    height: 100.0, // Height of each cube
                    margin: EdgeInsets.symmetric(horizontal: 8.0),
                    color: Colors.white,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Image.network(
                        imageUrls[index], // Load image from the URL
                        fit: BoxFit.cover, // Cover the entire cube
                      ),
                    ),
                  ),
                  SizedBox(height: 8.0), // Add spacing between the cube and the text
                  Text(
                    imageTxt[index], // Text below each cube
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        SizedBox(height: 10.0),
        Expanded(
          child: ListView.builder(
            itemCount: listImageUrls.length,
            itemBuilder: (context, index) {
              return Card(
                color: Colors.white,
                margin: EdgeInsets.all(16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
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
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.network(
                                  listImageUrls[index],
                                  width: 50,
                                  height: 50,
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
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 8.0),
                                    Text(
                                      listTime[index],
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          // Settings Icon
                          Positioned(
                            right: 0,
                            top: 0,
                            child: IconButton(
                              icon: Icon(Icons.more_vert),
                              onPressed: () {
                                // Handle settings button press
                                print('Settings pressed for item $index');
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Middle part of the card: Content
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        listContent[index],
                        style: TextStyle(fontSize: 16.0),
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
                              print('Play');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              side: BorderSide(
                                color: Colors.grey, // Set the border color
                                width: 0.7, // Set the border width (boldness)
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0), // Optional: Make the border rounded
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.play_circle,
                                  color: Color(0xFF1D1DD1),
                                ),
                                SizedBox(width: 8.0),
                                Text(
                                  'Play',
                                  style: TextStyle(color: Colors.black),
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
                              side: BorderSide(
                                color: Colors.grey, // Set the border color
                                width: 0.7, // Set the border width (boldness)
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0), // Optional: Make the border rounded
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.add,
                                  color: Color(0xFF1D1DD1),
                                ),
                                SizedBox(width: 8.0),
                                Text(
                                  '',
                                  style: TextStyle(color: Colors.black),
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
                              side: BorderSide(
                                color: Colors.grey, // Set the border color
                                width: 0.7, // Set the border width (boldness)
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0), // Optional: Make the border rounded
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.download,
                                  color: Color(0xFF1D1DD1),
                                ),
                                SizedBox(width: 8.0),
                                Text(
                                  'Download',
                                  style: TextStyle(color: Colors.black),
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


void main() =>
    runApp(MaterialApp(
      home: DiscoverPage(),
    ));
