import 'package:audio_service/audio_service.dart';
import 'package:audiopin_frontend/pages/discover.dart';
import 'package:audiopin_frontend/pages/podcast_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
import 'services/audio_handler.dart';
import 'services/audio_clip_transcription_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   // Create an instance of the AudioClipTranscriptionService
  final audioClipService = AudioClipTranscriptionService();
  await dotenv.load(fileName: ".env");  // Load the .env file
  // Preload FFmpeg before initializing the app
  await audioClipService.preload();
  final handler = await AudioService.init(
    builder: () => PodcastAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.example.audiopin_frontend',
      androidNotificationChannelName: 'AudioPin',
      androidNotificationOngoing: true,
    ),
  );
  runApp(
    Provider<PodcastAudioHandler>.value(
      value: handler,
      child: const MyApp(),
    ),
  );
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
        '/homepage': (context) => HomePage(),
        '/discover': (context) => DiscoverPage(),
        '/preview': (context) => PreviewPage(),
        '/episode': (context) => EpisodePage(),
        '/setting': (context) => SettingPage(),
        '/library': (context) => LibraryPage(),
        '/import': (context) => const ImportPage(),
        '/interests': (context) => interestsPage.InterestsPage(),
        '/subscriptions': (context) => const SubscriptionsPage(),
        '/podcastplayer': (context)=> PodcastPlayerPage()
      }, // set Welcome as the first page of app
    );
  }
}
