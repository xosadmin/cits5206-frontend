import 'package:audiopin_frontend/pages/sign_in.dart';
import 'package:flutter/material.dart';

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // 添加了图标和文字的顶部装饰区域
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Image.asset(
                    'assets/icons/Group.png',
                    width: 127,
                    height: 89,
                  ),
                  Image.asset(
                    'assets/images/Podcast_doodle_illustration_1.png',
                    width: 488,
                    height: 326,
                  ),
                  Text(
                    'Welcome to AudioPin',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00008B),
                    ),
                  ),
                  Text(
                    'Discover thousands of podcasts from your favorite creators',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF41414E),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30), // padding
            // 创建账户按钮
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF00008B),
                minimumSize: Size(327, 52), // button size
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              onPressed: () {}, // button click event
              child: Text(
                'Create a free account',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
            // login button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFFFFFF),
                  side: BorderSide(color: Color(0xFF00008B)),
                  minimumSize: Size(327, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  )),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignInPage()),
                );
              }, // button click event
              child: Text(
                'Sign in',
                style: TextStyle(fontSize: 16, color: Color(0xFF41414E)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
