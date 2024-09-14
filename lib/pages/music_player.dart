import 'package:flutter/material.dart';

class MusicPlayerPage extends StatefulWidget {
  final VoidCallback toggleTheme; // Define the callback function

  const MusicPlayerPage({super.key, required this.toggleTheme}); // Accept the callback in the constructor
  @override
  State<MusicPlayerPage> createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage> {
  late bool _isDarkMode;
  @override
  Widget build(BuildContext context) {
    _isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Now Playing'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              _isDarkMode ? Icons.wb_sunny : Icons.nightlight, // Toggle icon based on theme
            ),
            onPressed: () {
              widget.toggleTheme(); // Call the toggle function
              setState(() {
                // Update _isDarkMode after the theme changes
                _isDarkMode = !_isDarkMode;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_horiz),
            onPressed: (){},
          )
        ],
      ),
    );
  }


}

