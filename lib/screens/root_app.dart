import 'dart:async';

import 'package:flutter/material.dart';
import 'package:online_course/providers/auth_provider.dart';
import 'package:online_course/screens/profile/account.dart';
import 'package:online_course/screens/announces.dart';
import 'package:online_course/screens/explore.dart';
import 'package:online_course/screens/home.dart';
import 'package:online_course/screens/course/my_courses.dart';
import 'package:online_course/services/auth_service.dart';
import 'package:online_course/theme/color.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import localization
import '../providers/course_provider.dart';
import '../widgets/banner.dart';
import '../widgets/bottombar_box.dart';
import '../widgets/bottombar_item.dart';
import '../widgets/snackbar.dart';

class RootApp extends StatefulWidget {
  const RootApp({Key? key}) : super(key: key);

  @override
  _RootAppState createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  int _activeTab = 0;
  List _barItems = [
    {"icon": "assets/icons/home.svg", "page": HomePage()},
    {"icon": "assets/icons/search.svg", "page": ExploreScreen()},
    {"icon": "assets/icons/play.svg", "page": MyCourseScreen()},
    {"icon": "assets/icons/chat.svg", "page": AnnouncesPage()},
    {"icon": "assets/icons/profile.svg", "page": AccountPage()},
  ];

  // Cooldown functionality variables
  int? remainingCooldownTime;
  Timer? cooldownTimer;
  bool isOnCooldown = false;

  @override
  void dispose() {
    cooldownTimer?.cancel(); // Cancel timer if the widget is disposed
    super.dispose();
  }

  void startCooldown(int duration) {
    setState(() {
      remainingCooldownTime = duration;
      isOnCooldown = true;
    });

    // Start the timer
    cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingCooldownTime == null || remainingCooldownTime! <= 0) {
        timer.cancel(); // Stop the timer when cooldown ends
        setState(() {
          isOnCooldown = false;
          remainingCooldownTime = null;
        });
      } else {
        setState(() {
          remainingCooldownTime = remainingCooldownTime! - 1; // Decrease time
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();

    // Fetch courses when AuthProvider indicates user is authenticated
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final courseProvider =
          Provider.of<CourseProvider>(context, listen: false);

      if (authProvider.isAuthenticated && (courseProvider.myCourses.isEmpty)) {
        courseProvider.fetchMyCourses();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, CourseProvider>(
      builder: (context, authProvider, courseProvider, child) {
        if (!authProvider.isAuthenticated) {
          Future.microtask(
              () => Navigator.pushReplacementNamed(context, '/login'));

          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } // Show banner if email is not verified
        return Scaffold(
          body: Column(
            children: [
              if (authProvider.student?.isEmailVerified == "false")
                VerificationBanner(
                  message:
                      AppLocalizations.of(context)!.email_not_verified_message,
                  buttonText: isOnCooldown
                      ? "${AppLocalizations.of(context)!.wait} ${remainingCooldownTime}s" // Cooldown button text
                      : AppLocalizations.of(context)!.send_verification_button,
                  onButtonPressed: () {
                    if (!isOnCooldown) {
                      _handleVerificationButtonPressed();
                    }
                  },
                ),

              // Main app content
              Expanded(child: _buildMainApp()),
            ],
          ),
          bottomNavigationBar: _buildBottomBar(),
        );
      },
    );
  }

  Widget _buildMainApp() {
    return IndexedStack(
      index: _activeTab,
      children: List.generate(
        _barItems.length,
        (index) => _barItems[index]["page"],
      ),
    );
  }

  Widget _buildBottomBar() {
    return CustomBottomBar(
      children: List.generate(
        _barItems.length,
        (index) => BottomBarItem(
          _barItems[index]["icon"],
          isActive: _activeTab == index,
          activeColor: AppColor.primary,
          color: AppColor.mainColor,
          onTap: () {
            setState(() {
              _activeTab = index;
            });
          },
        ),
      ),
    );
  }

  Future<void> _handleVerificationButtonPressed() async {
    final success = await AuthService.sendEmailVerification();

    // Use the reusable snackbar to display the result
    if (success) {
      SnackBarHelper.showSuccessSnackBar(
        context,
        AppLocalizations.of(context)!.verification_email_sent_success,
      );
      startCooldown(30); // Start cooldown only if the request is successful
    } else {
      SnackBarHelper.showErrorSnackBar(
        context,
        AppLocalizations.of(context)!.verification_email_sent_failure,
      );
    }
  }
}
