import 'package:audiopin_frontend/pages/discover.dart';
import 'package:flutter/material.dart';
import 'pages/get_started.dart';
import 'pages/welcome.dart';
import 'pages/sign_in.dart';
import 'pages/forgot_pwd.dart';
import 'pages/verify_mail.dart';
import 'pages/homepage.dart';
import 'pages/discover.dart';
import 'pages/preview.dart';
import 'pages/episode.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AudioPin',
      theme: ThemeData(
        // define global theme, such as color, font style
        scaffoldBackgroundColor: Color(0xFFFFFFFF),
        primarySwatch: Colors.blue,
        appBarTheme: AppBarTheme(backgroundColor: Colors.white),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: OnboardingPage(),
      routes: {
        '/welcome': (context) => Welcome(),
        '/sign_in': (context) => SignInPage(),
        '/forgot_pwd': (context) => ForgotPasswordPage(),
        '/verify_mail': (context) => VerifyEmailPage(),
        '/homepage': (context) => HomePage(),
        '/discover': (context) => DiscoverPage(),
        '/preview': (context) => PreviewPage(),
        '/episode': (context) => EpisodePage(),
      }, // set Welcome as the first page of app
    );
  }
}
