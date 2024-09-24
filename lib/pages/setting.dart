import 'package:audiopin_frontend/main.dart';
import 'package:flutter/material.dart';
import 'homepage.dart';
import 'discover.dart';
import 'library.dart';

class SettingPage extends StatefulWidget  {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
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
            title: Text(
              "Settings",
              style: TextStyle(
                fontFamily: 'EuclidCircularA',
                fontSize: 20,
              ),
            ),
            centerTitle: true,
          ),
          backgroundColor: Color(0xFFFCFCFF),
          body: SettingBody(),
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

class SettingBody extends StatefulWidget  {
  @override
  _SettingBodyState createState() => _SettingBodyState();
}


class _SettingBodyState extends State<SettingBody> {

  String imageUrl = 'assets/images/image1.jpg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Profile Image at the top center
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Center(
              child: CircleAvatar(
                radius: 48, // Half of 96 to make the diameter 96
                backgroundImage: AssetImage(imageUrl),
              ),
            ),
          ),
          // List of setting buttons
          Expanded(
            child: ListView(
              children: [
                _buildSettingButton(
                  context,
                  'Profile Setting',
                  Icons.arrow_forward_ios, // Right-side icon
                      () {
                    // Navigate to Profile Setting
                  },
                ),
                _buildSettingButton(
                  context,
                  'AudioPin Settings',
                  Icons.arrow_forward_ios, // Right-side icon
                      () {
                    // Navigate to AudioPin Settings
                  },
                ),
                _buildSettingButton(
                  context,
                  'Account Settings',
                  Icons.arrow_forward_ios, // Right-side icon
                      () {
                    // Navigate to Account Settings
                  },
                ),
                _buildSettingButton(
                  context,
                  'Personalisation',
                  Icons.arrow_forward_ios, // Right-side icon
                      () {
                    // Navigate to Personalisation
                  },
                ),
                _buildSettingButton(
                  context,
                  'App Info',
                  Icons.arrow_forward_ios, // Right-side icon
                      () {
                    // Navigate to App Info
                  },
                ),
                _buildSettingButton(
                  context,
                  'Support',
                  Icons.arrow_forward_ios, // Right-side icon
                      () {
                    // Navigate to Support
                  },
                ),
                _buildSettingButton(
                  context,
                  'Logout',
                  Icons.arrow_forward_ios, // Right-side icon
                      () {
                    // Implement logout functionality
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper function to build each setting button
  Widget _buildSettingButton(
      BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(3, 0, 2, 0), // Padding for each button
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4), // Button border radius 4px
        ),
        child: ListTile(
          title: Text(title, style: TextStyle(fontSize: 16),),
          trailing: Icon(icon, size: 20,), // Icon positioned on the right
          onTap: onTap,
        ),
      ),
    );
  }
}

void main() =>
    runApp(MaterialApp(
      home: SettingPage(),
    ));
