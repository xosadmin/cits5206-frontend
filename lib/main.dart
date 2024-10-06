import 'package:audiopin_frontend/pages/discover.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'pages/get_started.dart';
import 'pages/welcome.dart';
import 'pages/sign_in.dart';
import 'pages/sign_up.dart';
import 'pages/signup_setting.dart';
import 'pages/forgot_pwd.dart';
import 'pages/verify_mail.dart';
import 'pages/homepage.dart';
import 'pages/preview.dart';
import 'pages/episode.dart';
import 'pages/setting.dart';
import 'pages/library.dart';
import 'pages/import.dart';
import 'pages/interests.dart' as interestsPage;
import 'pages/subscriptions.dart';
import 'pages/pins.dart';
import 'pages/noteedit.dart';
import 'pages/profile_setting.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('userBox'); // Initialize Hive for Flutter

  runApp(const MyApp());
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
      home: const OnboardingPage(),
      routes: {
        '/get_started': (context) => const OnboardingPage(),
        '/welcome': (context) => const Welcome(),
        '/sign_in': (context) => const SignInPage(),
        '/sign_up': (context) => const SignUpPage(),
        '/signup_setting': (context) => const SignUpSetting(),
        '/forgot_pwd': (context) => const ForgotPasswordPage(),
        '/verify_mail': (context) => const VerifyEmailPage(),
        '/homepage': (context) => const HomePage(),
        '/discover': (context) => const DiscoverPage(),
        '/preview': (context) => const PreviewPage(),
        '/episode': (context) => const EpisodePage(),
        '/setting': (context) => const SettingPage(),
        '/library': (context) => const LibraryPage(),
        '/signup_setting': (context) => const SignUpSetting(),
        '/import': (context) => ImportPage(),
        '/pins':(context) => PinsPage(),
        '/noteedit':(context) => NoteEditPage(),
        '/profile_setting':(context) => ProfileSettingPage(),
        '/interests': (context) => const interestsPage.InterestsPage(),
        '/subscriptions': (context) =>
            ImportSubscriptionsPage(podcasts: const []),
      }, // set Welcome as the first page of app
    );
  }
}
