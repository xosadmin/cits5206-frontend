import 'package:flutter/material.dart';
import 'pages/welcome.dart';
import 'pages/sign_in.dart';
import 'pages/forgot_pwd.dart';
import 'pages/verify_mail.dart';

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
      home: Welcome(),
      routes: {
        '/sign_in': (context) => SignInPage(),
        '/forgot_pwd': (context) => ForgotPasswordPage(),
        '/verify_mail': (context) => VerifyEmailPage(),
      }, // set Welcome as the first page of app
    );
  }
}
