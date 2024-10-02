import 'package:audiopin_frontend/pages/homepage.dart';
import 'package:audiopin_frontend/api_service.dart';
import 'package:flutter/material.dart';

class InterestsPage extends StatefulWidget {
  const InterestsPage({super.key});

  @override
  _InterestsPageState createState() => _InterestsPageState();
}

class _InterestsPageState extends State<InterestsPage> {
  List<String> selectedInterests = [];

  // Mapping interest names to their corresponding IDs
  final Map<String, String> interestMap = {
    'Art': '1',
    'Music': '2',
    'Comedy': '3',
    'TV': '4',
    'Government': '5',
    'Sports': '6',
    'Crypto': '7',
    'Culture': '8',
    'Society': '9',
    'Business': '10',
    'Health': '11',
    'Education': '12',
  };

  final List<String> interests = [
    'Art',
    'Music',
    'Comedy',
    'TV',
    'Government',
    'Sports',
    'Crypto',
    'Culture',
    'Society',
    'Business',
    'Health',
    'Education'
  ];

  String? userID;

  @override
  void initState() {
    super.initState();
    _getUserID(); // Get the userID when the widget is initialized
  }

  // Function to get userID from Hive storage
  Future<void> _getUserID() async {
    String? id = await UserService.getUserID();
    setState(() {
      userID = id;
      print(
          'Retrieved userID: $userID'); // check if the userID is read correctly
    });
  }

  // Function to save interests using the setUserInterests API method
  Future<void> _saveInterests() async {
    if (userID != null && selectedInterests.isNotEmpty) {
      try {
        await ApiService.setUserInterests(userID!, selectedInterests);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } catch (e) {
        print('Failed to save interests: $e');
      }
    } else {
      print('User ID is null or no interests selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'Tell us what your',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const Text(
              'interests are',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 10,
              runSpacing: 10,
              children: interests.map((interest) {
                bool isSelected =
                    selectedInterests.contains(interestMap[interest]);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        selectedInterests.remove(interestMap[interest]);
                      } else {
                        selectedInterests.add(interestMap[interest]!);
                      }
                      // test to print selectedInterests list and interestMap[interest]
                      print("Selected interests: $selectedInterests");
                      print("Mapped interest ID: ${interestMap[interest]}");
                    });
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.black),
                      gradient: isSelected
                          ? const LinearGradient(
                              colors: [Color(0xFF00008B), Color(0xFF1D1DD1)],
                            )
                          : null,
                      color: !isSelected ? Colors.white : null,
                    ),
                    child: Text(
                      interest,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const Spacer(),
            SizedBox(
              width: 327,
              height: 52,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePage(),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Color(0xFF6B7680)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    )),
                child: const Text(
                  "I'll rather not",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 327,
              height: 52,
              child: ElevatedButton(
                onPressed: selectedInterests.isNotEmpty ? _saveInterests : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedInterests.isNotEmpty
                      ? const Color(0xFF00008B)
                      : const Color(0xFF6B7680),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
