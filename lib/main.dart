import 'package:flutter/material.dart';
import 'package:online_course/screens/auth/forget_password.dart';
import 'package:online_course/screens/auth/login.dart';
import 'package:online_course/screens/auth/reset_password.dart';
import 'package:online_course/screens/auth/signup.dart';
import 'package:online_course/screens/root_app.dart';
import 'package:online_course/screens/splash.dart';

import 'package:online_course/theme/color.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Beta Prime School',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColor.appBgColor,
        appBarTheme: AppBarTheme(
          toolbarHeight: 70,
          iconTheme: IconThemeData(
            color: Colors.white, // Set default back icon color
          ),
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.transparent,
        ),
      ),
      home: const SplashScreen(),
      // Default route
      routes: {
        '/root': (context) => const RootApp(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/forget-password': (context) => const ForgetPasswordScreen(),
        '/reset-password': (context) => const ResetPasswordScreen(),
      },
    );
  }
}
