import 'package:audio_service/audio_service.dart';
import 'package:audiopin_frontend/pages/pins_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../services/audio_handler.dart';
import '../services/podcast_index_api_service.dart';
import 'package:skeletonizer/skeletonizer.dart';
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
                MaterialPageRoute(builder: (context) => SettingPage()),
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
      body: DiscoverBody(),
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
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            } else if (index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PinsPage()),
              );
            } else if (index == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DiscoverPage()),
              );
            } else if (index == 3) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LibraryPage()),
              );
            } else if (index == 4) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingPage()),
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
  int selectedCategory = 0;
  String imageUrl = 'assets/images/note_exp.png';
  String noteContent = "Click to view details";
  List<String>? _cachedCategories;
  List<String> subs = [];
  List<String> noteIDs = [];
  List<String> noteDates = [];
  List<String> notePodids = [];
  List<Map<String, dynamic>> _trendingPodcasts = [];
  bool _isLoading = true;

  String removeHtmlTags(String htmlString) {
    final RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return htmlString.replaceAll(exp, '');
  }

  Widget _buildCategoryTags() {
    if (_cachedCategories == null) {
      return _buildSkeletonLoader();
    }

    return Container(
      height: 20.0,
      width: MediaQuery.of(context).size.width * 0.9,
      margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _cachedCategories!.length,
        itemBuilder: (context, index) {
          return ElevatedButton(
            onPressed: () {
              setState(() {
                _isSelectedCate =
                    List.generate(_cachedCategories!.length, (i) => i == index);
                selectedCategory = index + 1;
              });
              _fetchPodcastsByCategory(index + 1);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _isSelectedCate[index]
                  ? const Color(0xFF1D1DD1)
                  : Colors.white,
              side: BorderSide.none,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            child: Text(
              _cachedCategories![index],
              style: TextStyle(
                color: _isSelectedCate[index] ? Colors.white : Colors.black,
                fontSize: 10.0,
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _fetchPodcastsByCategory(int categoryId) async {
    setState(() => _isLoading = true);
    try {
      final response = await PodcastIndexApiService()
          .podcastsTrending(max: 10, cat: categoryId.toString());
      if (response['status'] == "true") {
        setState(() {
          _trendingPodcasts =
              List<Map<String, dynamic>>.from(response['feeds']);
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load podcasts');
      }
    } catch (e) {
      print('Error fetching podcasts: $e');
      setState(() => _isLoading = false);
    }
  }

  Widget _buildSkeletonLoader() {
    return Container(
      height: 20.0,
      width: MediaQuery.of(context).size.width * 0.9,
      margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) {
          return Skeletonizer(
            enabled: true,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300],
                side: BorderSide.none,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              child: Text(
                'Loading...',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 10.0,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Initialize the list with false values indicating no button is selected initially
    _isSelectedCate = List.generate(imageUrls.length, (index) => false);
    selectedCategory = 0;
    _fetchTrendingPodcasts();
    _fetchCategories();
    getNotes();
    loadDatas();
  }

  Future<void> _fetchCategories() async {
    try {
      final categories = await getCategoriesText();
      setState(() {
        _cachedCategories = categories;
        _isSelectedCate = List.generate(categories.length, (index) => false);
      });
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  void loadDatas() async {
    List<List<String>> fetchedLists = await getNotes();
    setState(() {
      if (fetchedLists.isNotEmpty && fetchedLists.length == 3) {
        noteIDs = fetchedLists[0];
        notePodids = fetchedLists[1];
        noteDates = fetchedLists[2];
      }
    });
    print('$noteIDs $noteDates $notePodids');
  }

  Future<void> _fetchTrendingPodcasts() async {
    try {
      final response = await PodcastIndexApiService()
          .podcastsTrending(max: 10, cat: selectedCategory.toString());
      if (response['status'] == "true") {
        setState(() {
          _trendingPodcasts =
              List<Map<String, dynamic>>.from(response['feeds']);
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load podcasts');
      }
    } catch (e) {
      print('Error fetching podcasts: $e');
      setState(() => _isLoading = false);
    }
  }

  Widget _buildSkeletonListLoader() {
    return Skeletonizer(
      enabled: true,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) => _buildPodcastItem({
          'title': 'Loading...',
          'author': 'Author',
          'artwork': 'https://via.placeholder.com/64.png',
        }),
      ),
    );
  }

  Widget _buildPodcastList() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: _trendingPodcasts.length,
      itemBuilder: (context, index) =>
          _buildPodcastItem(_trendingPodcasts[index]),
    );
  }

  void addEpisodesToQueue(
      BuildContext context, List<Map<String, dynamic>> episodes) {
    final handler = Provider.of<PodcastAudioHandler>(context, listen: false);

    // Step 1: Convert each episode to a MediaItem
    List<MediaItem> mediaItems = episodes.map((episode) {
      return MediaItem(
        id: episode['enclosureUrl'] ??
            '', // enclosureUrl is used as the unique ID
        title: episode['title'] ?? '',
        album: episode['feedUrl'] ??
            '', // Assuming feedUrl as the album (or use another field)
        artist: episode['persons'] != null && episode['persons'].isNotEmpty
            ? episode['persons'][0]['name'] // First person as artist
            : '',
        duration:
            Duration(seconds: episode['duration'] ?? 0), // Episode duration
        artUri: Uri.parse(episode['feedImage'] ?? ''), // Podcast cover art URL
      );
    }).toList();

    // Step 2: Use the handler to add the items to the queue
    handler.addQueueItems(mediaItems);
  }

  Widget _buildPodcastItem(Map<String, dynamic> podcast) {
    return GestureDetector(
      onTap: () async {
        var episodeResponse =
            await PodcastIndexApiService().episodesByFeedId(podcast['id']);
        var items = episodeResponse['items'];

        if (items is List) {
          // Safely cast and filter
          var episodes = items
              .whereType<Map<String, dynamic>>() // Ensure each item is a Map
              .toList();
          addEpisodesToQueue(context, episodes);
          Navigator.pushNamed(context, '/podcastplayer');

          // Now episodes will be of type List<Map<String, dynamic>>
          print(episodes); // Debugging line to check the contents
        } else {
          // Handle the case where items is not a List
          throw Exception("Expected a list but got ${items.runtimeType}");
        }
      },
      child: Container(
        width: 80.0,
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 64.0,
              height: 64.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5.0),
                child: FadeInImage.assetNetwork(
                  image: podcast['artwork'] ?? podcast['image'] ?? '',
                  placeholder:
                      'assets/images/Podcast_doodle_illustration_1.png',
                  fit: BoxFit.cover,
                  fadeInDuration: const Duration(milliseconds: 300),
                  fadeInCurve: Curves.easeIn,
                  imageErrorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.error),
                ),
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              podcast['title'] ?? '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12.0),
            ),
            const SizedBox(height: 4.0),
            Text(
              podcast['author'] ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 10.0, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  final List<String> imageUrls = [
    'assets/images/note1.png',
    'assets/images/note2.png',
    'assets/images/note3.png',
    'assets/images/note4.png',
    'assets/images/note5.png',
  ];

  List<String> cateText = [];

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
    return ListView(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              margin:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              height: 34.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(3.0),
                border: Border.all(color: Colors.grey),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.grey, size: 14.0),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: TextField(
                      style: const TextStyle(
                        fontSize: 12.0,
                      ),
                      decoration: const InputDecoration(
                        hintText: "Search for podcasts",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 14.0),
                      ),
                      onChanged: (value) {
                        print("Search query: $value");
                      },
                    ),
                  ),
                ],
              ),
            ),
            _buildCategoryTags(),
            const SizedBox(height: 4.0),
            Container(
              width: MediaQuery.of(context).size.width * 0.92,
              margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.04),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1A282626),
                    offset: Offset(0, 1),
                    blurRadius: 4.0,
                    spreadRadius: 0.0,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Featured',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 140.0,
                    child: _isLoading
                        ? _buildSkeletonListLoader()
                        : _buildPodcastList(),
                  ),
                  const SizedBox(height: 10.0),
                ],
              ),
            ),
            const SizedBox(height: 15.0),
          ],
        ),
        // New section to display trending content as a list
        ..._buildTrendingContentList(),
      ],
    );
  }

  List<Widget> _buildTrendingContentList() {
    return _trendingPodcasts.map((podcast) {
      return Card(
        color: Colors.white,
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(5.0),
                child: Image.network(
                  podcast['artwork'] ?? podcast['image'] ?? '',
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.error),
                ),
              ),
              title: Text(
                podcast['title'] ?? '',
                style: const TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                podcast['author'] ?? '',
                style: const TextStyle(
                  fontSize: 12.0,
                  color: Colors.grey,
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return BottomOptions();
                    },
                  );
                },
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Text(
                removeHtmlTags(
                    podcast['description'] ?? 'No description available.'),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () async {
                      Navigator.pushNamed(context, '/podcastplayer');

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                'Episodes added to the top of the queue and playing')),
                      );
                      await _handlePlayButton(podcast);
                    },
                    icon: const Icon(Icons.play_arrow, size: 18),
                    label: const Text('Play'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      Navigator.pushNamed(context, '/podcastplayer');

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                'Episodes added to the top of the queue and playing')),
                      );
                      await _handleAddToQueueButton(podcast);
                    },
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add to queue'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Implement download functionality
                    },
                    icon: const Icon(Icons.download, size: 18),
                    label: const Text('Download'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  Future<void> _handlePlayButton(Map<String, dynamic> podcast) async {
    final handler = Provider.of<PodcastAudioHandler>(context, listen: false);

    try {
      // Check if podcast ID exists
      if (podcast['id'] == null) {
        throw Exception("Podcast ID is null.");
      }

      // Fetch episodes from the API
      var episodeResponse =
          await PodcastIndexApiService().episodesByFeedId(podcast['id']);

      // Check if the response contains a valid list of items
      var items = episodeResponse['items'];
      if (items is! List) {
        throw Exception(
            "Expected a list of episodes but got ${items.runtimeType}");
      }

      // Ensure the list contains valid episode data
      var episodes = items.whereType<Map<String, dynamic>>().toList();
      if (episodes.isEmpty) {
        throw Exception("No valid episodes found.");
      }

      // Convert episodes to MediaItems
      List<MediaItem> mediaItems = _convertEpisodesToMediaItems(episodes);

      if (mediaItems.isEmpty) {
        throw Exception("Failed to convert episodes to MediaItems.");
      }

      // Add episodes to the top of the queue and start playing the first one
      await handler.addQueueItemsAtTop(mediaItems);
      await handler.play();
    } catch (e) {
      print("Error handling play button: $e");

      // Ensure the widget is still mounted before showing a SnackBar
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to play podcast. Please try again.')),
        );
      }
    }
  }

  Future<void> _handleAddToQueueButton(Map<String, dynamic> podcast) async {
    final handler = Provider.of<PodcastAudioHandler>(context, listen: false);

    try {
      var episodeResponse =
          await PodcastIndexApiService().episodesByFeedId(podcast['id']);
      var items = episodeResponse['items'];

      if (items is List) {
        var episodes = items.whereType<Map<String, dynamic>>().toList();
        List<MediaItem> mediaItems = _convertEpisodesToMediaItems(episodes);

        // Add the new episodes to the end of the queue
        await handler.addQueueItems(mediaItems);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Episodes added to queue')),
        );
      } else {
        throw Exception(
            "Expected a list of episodes but got ${items.runtimeType}");
      }
    } catch (e) {
      print("Error handling add to queue button: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Failed to add episodes to queue. Please try again.')),
      );
    }
  }

  List<MediaItem> _convertEpisodesToMediaItems(
      List<Map<String, dynamic>> episodes) {
    return episodes.map((episode) {
      return MediaItem(
        id: episode['enclosureUrl'] ?? '',
        title: episode['title'] ?? '',
        album: episode['feedTitle'] ?? '',
        artist: episode['feedAuthor'] ?? '',
        duration: Duration(seconds: episode['duration'] ?? 0),
        artUri: Uri.parse(episode['feedImage'] ?? ''),
      );
    }).toList();
  }

  // Simulated asynchronous function to fetch the category text.
  Future<List<String>> getCategoriesText() async {
    Map<String, dynamic> response =
        await PodcastIndexApiService().categoriesList();
    if (response['status'] == 'true') {
      List<dynamic> feeds = response['feeds'];
      return feeds.map((feed) => feed['name'].toString()).toList();
    } else {
      return ['For you', 'News', 'Culture', 'Cryptocurrency', 'Education'];
    }
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

void main() => runApp(MaterialApp(
      home: DiscoverPage(),
    ));
