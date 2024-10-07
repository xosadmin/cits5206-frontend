import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/pin.dart';
import 'rich_text_editor_page.dart'; // Make sure to import the file containing RichTextEditorPage and Pin class

enum SortOption { titleAsc, titleDesc, dateCreatedAsc, dateCreatedDesc }

class PinsPage extends StatefulWidget {
  static const routeName = '/pins';

  const PinsPage({Key? key}) : super(key: key);

  @override
  _PinsPageState createState() => _PinsPageState();
}

class _PinsPageState extends State<PinsPage> {
  List<Pin> _pins = [];
  List<Pin> _filteredPins = [];
  TextEditingController _searchController = TextEditingController();
  SortOption _currentSortOption = SortOption.dateCreatedDesc;

  @override
  void initState() {
    super.initState();
    _loadPins();
  }

  Future<void> _loadPins() async {
    final prefs = await SharedPreferences.getInstance();
    final pinIds = prefs.getStringList('pin_ids') ?? [];
    List<Pin> loadedPins = [];

    for (String id in pinIds) {
      final pinJson = prefs.getString('pin_$id');
      if (pinJson != null) {
        loadedPins.add(Pin.fromJson(json.decode(pinJson)));
      }
    }

    setState(() {
      _pins = loadedPins;
      _sortPins();
      _filterPins(_searchController.text);
    });
  }

  void _filterPins(String query) {
    setState(() {
      _filteredPins = _pins.where((pin) {
        return pin.title.toLowerCase().contains(query.toLowerCase()) ||
            pin.content.toLowerCase().contains(query.toLowerCase()) ||
            pin.tags
                .any((tag) => tag.toLowerCase().contains(query.toLowerCase()));
      }).toList();
      _sortPins();
    });
  }

  void _sortPins() {
    switch (_currentSortOption) {
      case SortOption.titleAsc:
        _filteredPins.sort((a, b) => a.title.compareTo(b.title));
        break;
      case SortOption.titleDesc:
        _filteredPins.sort((a, b) => b.title.compareTo(a.title));
        break;
      case SortOption.dateCreatedAsc:
        _filteredPins
            .sort((a, b) => int.parse(a.id).compareTo(int.parse(b.id)));
        break;
      case SortOption.dateCreatedDesc:
        _filteredPins
            .sort((a, b) => int.parse(b.id).compareTo(int.parse(a.id)));
        break;
    }
  }

  Future<void> _deletePin(Pin pin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('pin_${pin.id}');

    final pinIds = prefs.getStringList('pin_ids') ?? [];
    pinIds.remove(pin.id);
    await prefs.setStringList('pin_ids', pinIds);

    setState(() {
      _pins.remove(pin);
      _filterPins(_searchController.text);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Pin deleted')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Pins'),
        actions: [
          PopupMenuButton<SortOption>(
            icon: Icon(Icons.sort),
            onSelected: (SortOption result) {
              setState(() {
                _currentSortOption = result;
                _sortPins();
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<SortOption>>[
              const PopupMenuItem<SortOption>(
                value: SortOption.titleAsc,
                child: Text('Sort by Title (A-Z)'),
              ),
              const PopupMenuItem<SortOption>(
                value: SortOption.titleDesc,
                child: Text('Sort by Title (Z-A)'),
              ),
              const PopupMenuItem<SortOption>(
                value: SortOption.dateCreatedAsc,
                child: Text('Sort by Date (Oldest first)'),
              ),
              const PopupMenuItem<SortOption>(
                value: SortOption.dateCreatedDesc,
                child: Text('Sort by Date (Newest first)'),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RichTextEditorPage()),
              );
              _loadPins(); // Reload pins after returning from the editor
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search pins...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: _filterPins,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredPins.length,
              itemBuilder: (context, index) {
                final pin = _filteredPins[index];
                return Dismissible(
                  key: Key(pin.id),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    _deletePin(pin);
                  },
                  child: ListTile(
                    title: Text(pin.title),
                    subtitle: Text(pin.content.length > 50
                        ? '${pin.content.substring(0, 50)}...'
                        : pin.content),
                    trailing: Wrap(
                      children: pin.tags
                          .map((tag) => Chip(label: Text(tag)))
                          .toList(),
                    ),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RichTextEditorPage(pin: pin),
                        ),
                      );
                      _loadPins(); // Reload pins after returning from the editor
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
