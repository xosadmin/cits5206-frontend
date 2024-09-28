import 'package:flutter/material.dart';

class MusicPlayerPage extends StatefulWidget {
  const MusicPlayerPage({super.key});
  @override
  State<MusicPlayerPage> createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage> {
 // bool _isClicked = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Now Playing'),
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.nightlight),
            onPressed: (){},
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

