import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:online_course/providers/auth_provider.dart';
import 'package:online_course/providers/course_provider.dart';
import 'package:online_course/providers/teacher_provider.dart';
import 'package:online_course/screens/auth/forget_password.dart';
import 'package:online_course/screens/auth/login.dart';
import 'package:online_course/screens/auth/reset_password.dart';
import 'package:online_course/screens/auth/signup.dart';
import 'package:online_course/screens/payments/failed.dart';
import 'package:online_course/screens/payments/success.dart';
import 'package:online_course/screens/root_app.dart';
import 'package:online_course/screens/splash.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:online_course/screens/verify_email.dart';
import 'package:online_course/theme/color.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:online_course/utils/logger.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  // Ensure the environment file is loaded correctly
  await dotenv.load(fileName: ".env.development");

  Logger.enable();

  // Initialize the provider before running the app
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => TeacherProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CourseProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
        )
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  static final ValueNotifier<Locale> currentLocale =
      ValueNotifier<Locale>(Locale("ar"));

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  late AppLinks _appLinks;
  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    _appLinks = AppLinks();
    _handleIncomingLinks();
    WidgetsBinding.instance.addObserver(this);
  }

  void _handleIncomingLinks() {
    _sub = _appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        if (uri.host == 'reset-password') {
          final token = uri.queryParameters['token'];
          if (token != null) {
            // Use navigatorKey to push the route
            navigatorKey.currentState?.push(
              MaterialPageRoute(
                builder: (context) => ResetPasswordScreen(token: token),
              ),
            );
          }
        } else if (uri.host == 'verify') {
          final token = uri.queryParameters['token'];
          if (token != null) {
            navigatorKey.currentState?.push(
              MaterialPageRoute(
                builder: (context) => VerifyEmailScreen(token: token),
              ),
            );
          }
        } else if (uri.host == 'payment-success') {
          final checkout_id = uri.queryParameters['checkout_id'];
          if (checkout_id != null) {
            navigatorKey.currentState?.push(
              MaterialPageRoute(
                builder: (context) =>
                    PaymentSuccessPage(checkoutId: checkout_id),
              ),
            );
          }
        } else if (uri.host == 'payment-failed') {
          final checkout_id = uri.queryParameters['checkout_id'];
          if (checkout_id != null) {
            navigatorKey.currentState?.push(
              MaterialPageRoute(
                builder: (context) =>
                    PaymentFailedPage(checkoutId: checkout_id),
              ),
            );
          }
        }
      }
    }, onError: (Object err) {
      print('Error handling deep link: $err');
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _sub?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (state == AppLifecycleState.resumed) {
      authProvider.handleWindowFocus();
    } else if (state == AppLifecycleState.paused) {
      authProvider.handleWindowBlur();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: MyApp.currentLocale,
      builder: (context, locale, _) {
        return Consumer<AuthProvider>(
          builder: (context, auth, _) {
            return MaterialApp(
              navigatorKey: navigatorKey,
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
                  ? SplashScreen(MyApp.currentLocale.value)
                  : auth.isAuthenticated
                      ? const RootApp()
                      : const LoginScreen(),
              routes: {
                '/root': (context) => const RootApp(),
                '/login': (context) => const LoginScreen(),
                '/signup': (context) => const SignupScreen(),
                '/forget-password': (context) => const ForgetPasswordScreen(),
                '/reset-password': (context) =>
                    const ResetPasswordScreen(token: ''),
                '/verify': (context) => const VerifyEmailScreen(
                      token: '',
                    ),
              },
            );
          },
        );
      },
    );
  }
}
