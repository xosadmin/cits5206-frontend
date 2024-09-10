import 'package:flutter/material.dart';
import 'pages/get_started.dart';
import 'pages/welcome.dart';
import 'pages/sign_in.dart';
import 'pages/sign_up.dart';
import 'pages/signup_setting.dart';
import 'pages/forgot_pwd.dart';
import 'pages/verify_mail.dart';
import 'pages/signup_setting.dart';

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
        '/get_started': (context) => OnboardingPage(),
        '/welcome': (context) => Welcome(),
        '/sign_in': (context) => SignInPage(),
        '/sign_up': (context) => SignUpPage(),
        '/signup_setting': (context) => SignUpSetting(),
        '/forgot_pwd': (context) => ForgotPasswordPage(),
        '/verify_mail': (context) => VerifyEmailPage(),
        '/signup_setting': (context) => SignUpSetting(),
      }, // set Welcome as the first page of app
    );
  }
}
