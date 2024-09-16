import 'package:flutter/material.dart';

class InterestsPage extends StatefulWidget {
  const InterestsPage({super.key});

  @override
  _InterestsPageState createState() => _InterestsPageState();
}

class _InterestsPageState extends State<InterestsPage> {
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

  final Set<String> selectedInterests = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Interests')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 第一部分: 标题
            const Text(
              'Tell us what your interests are',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // 第二部分: 标签选择
            Wrap(
              spacing: 12.0,
              runSpacing: 12.0,
              children: interests.map((interest) {
                final isSelected = selectedInterests.contains(interest);
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? const LinearGradient(
                              colors: [Color(0xFF00008B), Color(0xFF1D1DD1)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : null,
                      color: isSelected ? null : Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: isSelected ? Colors.transparent : Colors.grey,
                      ),
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

            const SizedBox(height: 20),

            // 第三部分: 按钮
            if (selectedInterests.isEmpty)
              TextButton(
                onPressed: () {
                  // 跳过逻辑
                },
                child: const Text('I’ll rather not'),
              ),

            const SizedBox(height: 20),

            // Continue 按钮
            SizedBox(
              width: 327,
              height: 52,
              child: ElevatedButton(
                onPressed: selectedInterests.isEmpty
                    ? null
                    : () {
                        // Continue 按钮逻辑
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedInterests.isEmpty
                      ? const Color(0xFF6B7680) // 灰色状态
                      : const Color(0xFF00008B), // 深蓝色
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
