import 'package:audiopin_frontend/pages/discover.dart';
import 'package:flutter/material.dart';
import 'pages/get_started.dart';
import 'pages/welcome.dart';
import 'pages/sign_in.dart';
import 'pages/sign_up.dart';
import 'pages/signup_setting.dart';
import 'pages/forgot_pwd.dart';
import 'pages/verify_mail.dart';
import 'pages/homepage.dart';
import 'pages/discover.dart';
import 'pages/preview.dart';
import 'pages/episode.dart';
import 'pages/setting.dart';
import 'pages/library.dart';
import 'pages/signup_setting.dart';
import 'pages/import.dart';
import 'pages/interests.dart' as interestsPage;
import 'pages/subscriptions.dart';
import 'pages/pins.dart';
import 'pages/noteedit.dart';
import 'pages/profile_setting.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AudioPin',
      theme: ThemeData(
        // define global theme, such as color, font style
        scaffoldBackgroundColor: const Color(0xFFFFFFFF),
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: OnboardingPage(),
      routes: {
        '/get_started': (context) => OnboardingPage(),
        '/welcome': (context) => Welcome(),
        '/sign_in': (context) => SignInPage(),
        '/sign_up': (context) => SignUpPage(),
        '/signup_setting': (context) => SignUpSetting(),
        '/forgot_pwd': (context) => ForgotPasswordPage(),
        '/verify_mail': (context) => VerifyEmailPage(),
        '/homepage': (context) => HomePage(),
        '/discover': (context) => DiscoverPage(),
        '/preview': (context) => PreviewPage(),
        '/episode': (context) => EpisodePage(),
        '/setting': (context) => SettingPage(),
        '/library': (context) => LibraryPage(),
        '/signup_setting': (context) => SignUpSetting(),
        '/import': (context) => ImportPage(),
        '/interests': (context) => interestsPage.InterestsPage(),
        '/subscriptions': (context) => SubscriptionsPage(),
        '/pins':(context) => PinsPage(),
        '/noteedit':(context) => NoteEditPage(),
        '/profile_setting':(context) => ProfileSettingPage(),
      }, // set Welcome as the first page of app
    );
  }
}
