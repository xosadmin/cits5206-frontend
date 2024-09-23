import 'package:audiopin_frontend/core/themes/theme.dart';
import 'package:audiopin_frontend/pages/discover.dart';
import 'package:flutter/material.dart';
import 'pages/welcome.dart';
import 'pages/sign_in.dart';
import 'pages/forgot_pwd.dart';
import 'pages/verify_mail.dart';
import 'pages/homepage.dart';
import 'pages/music_player.dart';

void main() {
  runApp(const MyApp());
}



class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system; // Initially system theme

  void _toggleThemeMode() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AudioPin',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xFF00008B)
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.blueGrey,
      ),
      themeMode: ThemeMode.system,
      home: MusicPlayerPage(toggleTheme: _toggleThemeMode),
      routes: {
        '/welcome': (context) => const Welcome(),
        '/sign_in': (context) => const SignInPage(),
        '/forgot_pwd': (context) => const ForgotPasswordPage(),
        '/verify_mail': (context) => const VerifyEmailPage(),
        '/homepage': (context) => const HomePage(),
        '/discover': (context) => const DiscoverPage(),
        '/music_player': (context) =>
            MusicPlayerPage(toggleTheme: _toggleThemeMode),
      },
    );
  }
}
