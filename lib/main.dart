import 'package:audiopin_frontend/pages/discover.dart';
import 'package:flutter/material.dart';
import 'pages/get_started.dart';
import 'pages/welcome.dart';
import 'pages/sign_in.dart';
import 'pages/forgot_pwd.dart';
import 'pages/verify_mail.dart';
import 'pages/homepage.dart';
import 'pages/music_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AudioPin',
      theme: ThemeData(
        // define global theme, such as color, font style
        scaffoldBackgroundColor: const Color(0xFFFFFFFF),
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
        visualDensity: VisualDensity.adaptivePlatformDensity
      ),
      home: const MusicPlayerPage(),
      routes: {
        '/welcome': (context) => const Welcome(),
        '/sign_in': (context) => const SignInPage(),
        '/forgot_pwd': (context) => const ForgotPasswordPage(),
        '/verify_mail': (context) => const VerifyEmailPage(),
        '/homepage': (context) => const HomePage(),
        '/discover': (context) => const DiscoverPage(),
        '/music_player': (context) => const MusicPlayerPage()
      },
    );
  }
}
