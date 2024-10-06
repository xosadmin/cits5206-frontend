import 'package:flutter/material.dart';

class SubscriptionsPage extends StatefulWidget {
  const SubscriptionsPage({super.key});

  @override
  _SubscriptionsPageState createState() => _SubscriptionsPageState();
}

class _SubscriptionsPageState extends State<SubscriptionsPage> {
  bool _isFollowing = true; // 是否关注所有播客
  final List<String> podcastNames = [
    "Dateline NBC",
    "The Daily",
    "DatStuff You Should Know"
  ];
  final List<String> podcastImages = [
    "assets/images/podcast1.png",
    "assets/images/podcast2.png",
    "assets/images/podcast3.png"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Import your subscriptions'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 第一部分：标题和说明文本
            const SizedBox(height: 20),
            const Text(
              'Import your subscriptions',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'We can find shows from Apple Podcasts if you have an episode from the show downloaded',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // 第二部分：找到的节目数+取消关注按钮
            const Text(
              'We found 3 shows',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: 327,
              height: 52,
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    _isFollowing = !_isFollowing; // 切换关注状态
                  });
                },
                child: Text(_isFollowing ? 'Unfollow all' : 'Follow all'),
              ),
            ),
            const SizedBox(height: 16),

            // 第三部分：播客封面、名称和关注按钮
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(podcastNames.length, (index) {
                return Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        image: DecorationImage(
                          image: AssetImage(podcastImages[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: 80,
                      child: Text(
                        podcastNames[index],
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: 80,
                      height: 23,
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _isFollowing = !_isFollowing;
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                              color: _isFollowing ? Colors.blue : Colors.grey),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: Text(
                          _isFollowing ? 'Following' : 'Follow',
                          style: TextStyle(
                            fontSize: 12,
                            color: _isFollowing ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
            const Spacer(),

            // 第四部分：继续按钮
            SizedBox(
              width: 327,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => InterestsPage()), // 跳转到兴趣页面
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00008B),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(
                    fontSize: 16,
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

class InterestsPage extends StatelessWidget {
  const InterestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Interests'),
      ),
      body: const Center(
        child: Text('Interests Page Content Here'),
      ),
    );
  }
}
