import 'package:flutter/material.dart';

class InterestsPage extends StatefulWidget {
  const InterestsPage({super.key});

  @override
  _InterestsPageState createState() => _InterestsPageState();
}

class _InterestsPageState extends State<InterestsPage> {
  List<String> selectedInterests = [];

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
            // 第一部分：标题
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
            // 第二部分：兴趣标签
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 10,
              runSpacing: 10,
              children: interests.map((interest) {
                bool isSelected = selectedInterests.contains(interest);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        selectedInterests.remove(interest);
                      } else {
                        selectedInterests.add(interest);
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
            // 第三部分：按钮
            SizedBox(
              width: 327,
              height: 52,
              child: OutlinedButton(
                onPressed: selectedInterests.isNotEmpty
                    ? () {
                        // Continue button logic
                      }
                    : null,
                style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Color(0xFF6B7680)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    )),
                child: Text(
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
                onPressed: selectedInterests.isNotEmpty
                    ? () {
                        // Navigate to next page
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedInterests.isNotEmpty
                      ? const Color(0xFF00008B)
                      : const Color(0xFF6B7680),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: Text(
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
