import 'package:flutter/material.dart';
import 'package:online_course/screens/auth/forget_password.dart';
import 'package:online_course/screens/auth/login.dart';
import 'package:online_course/screens/auth/reset_password.dart';
import 'package:online_course/screens/auth/signup.dart';
import 'package:online_course/screens/root_app.dart';
import 'package:online_course/screens/splash.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:online_course/theme/color.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final ValueNotifier<Locale> currentLocale =
      ValueNotifier<Locale>(Locale("ar")); // Default: French

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: currentLocale,
      builder: (context, locale, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Beta Prime School',
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: locale,
          // Set the app's locale dynamically
          theme: ThemeData(
            scaffoldBackgroundColor: AppColor.appBgColor,
            appBarTheme: const AppBarTheme(
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
          routes: {
            '/root': (context) => const RootApp(),
            '/login': (context) => const LoginScreen(),
            '/signup': (context) => const SignupScreen(),
            '/forget-password': (context) => const ForgetPasswordScreen(),
            '/reset-password': (context) => const ResetPasswordScreen(),
          },
        );
      },
    );
  }
}

// Language Switcher Function
void switchLanguage(String languageCode) {
  MyApp.currentLocale.value = Locale(languageCode);
}
