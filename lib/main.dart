import 'package:flutter/material.dart';
import 'package:online_course/screens/auth/forget_password.dart';
import 'package:online_course/screens/auth/login.dart';
import 'package:online_course/screens/auth/reset_password.dart';
import 'package:online_course/screens/auth/signup.dart';
import 'package:online_course/screens/root_app.dart';

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
        primaryColor: AppColor.primary,
      ),
      initialRoute: '/',
      // Default route
      routes: {
        '/': (context) => const RootApp(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/forget-password': (context) => const ForgetPasswordScreen(),
        '/reset-password': (context) => const ResetPasswordScreen(),
      },
    );
  }
}
