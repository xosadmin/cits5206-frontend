import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart'; // 引入 smooth_page_indicator

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: const Color(0xFF00008B),
              height: 170,
            ),
          ),
          Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(48),
                        bottomRight: Radius.circular(48),
                      ),
                      child: Container(
                        color: Colors.white,
                        child: PageView(
                          controller: _pageController,
                          children: [
                            _buildPage(
                              imagePath: 'assets/images/Asset_11.png',
                              title: 'Discover Your \nFavorite Podcast',
                              description:
                                  'It\'s time to learn something new \n and interesting',
                              context: context,
                            ),
                            _buildPage(
                              imagePath: 'assets/images/Asset_21.png',
                              title: 'Find Your Favorites',
                              description:
                                  'Find, enjoy and rate the \n podcasts you love',
                              context: context,
                            ),
                            _buildPage(
                              imagePath: 'assets/images/Asset_41.png',
                              title: 'Import Playlist',
                              description:
                                  'Import your playlists from \n other platforms with ease',
                              context: context,
                            ),
                            _buildPage(
                              imagePath: 'assets/images/Layer_2.png',
                              title: 'In App Note',
                              description:
                                  'Discover, find, import, \n take and display note',
                              context: context,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: SmoothPageIndicator(
                          controller: _pageController,
                          count: 4,
                          effect: const JumpingDotEffect(
                            dotWidth: 10,
                            dotHeight: 10,
                            activeDotColor: Colors.black,
                            dotColor: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Navigate to the welcome.dart page
                  Navigator.pushReplacementNamed(context, '/welcome');
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  backgroundColor: const Color(0xFF00008B),
                ),
                child: const Text('Get Started >>',
                    style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPage({
    required String imagePath,
    required String title,
    required String description,
    required BuildContext context,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(imagePath, height: 300),
        const SizedBox(height: 20),
        RichText(
          textAlign: TextAlign.center,
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'Discover Your\n',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00008B),
                ),
              ),
              TextSpan(
                text: 'Favorite Podcast',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00008B),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Text(
          description,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ],
    );
  }
}
