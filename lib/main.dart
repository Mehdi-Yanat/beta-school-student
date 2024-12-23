import 'package:flutter/material.dart';
import 'package:online_course/providers/auth_provider.dart';
import 'package:online_course/screens/auth/forget_password.dart';
import 'package:online_course/screens/auth/login.dart';
import 'package:online_course/screens/auth/reset_password.dart';
import 'package:online_course/screens/auth/signup.dart';
import 'package:online_course/screens/root_app.dart';
import 'package:online_course/screens/splash.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:online_course/theme/color.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:online_course/utils/logger.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  // Ensure the environment file is loaded correctly
  await dotenv.load(fileName: ".env.production");

  Logger.enable();

  // Initialize the provider before running the app
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
        )
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  static final ValueNotifier<Locale> currentLocale =
      ValueNotifier<Locale>(Locale("ar"));

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: currentLocale,
      builder: (context, locale, _) {
        return Consumer<AuthProvider>(
          builder: (context, auth, _) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Beta Prime School',
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              locale: locale,
              theme: ThemeData(
                scaffoldBackgroundColor: AppColor.appBgColor,
                appBarTheme: const AppBarTheme(
                  toolbarHeight: 70,
                  iconTheme: IconThemeData(
                    color: Colors.white,
                  ),
                  elevation: 0,
                  centerTitle: true,
                  backgroundColor: Colors.transparent,
                ),
              ),
              home: auth.isLoading
                  ? SplashScreen(currentLocale.value)
                  : auth.isAuthenticated
                      ? const RootApp()
                      : const LoginScreen(),
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
      },
    );
  }
}
