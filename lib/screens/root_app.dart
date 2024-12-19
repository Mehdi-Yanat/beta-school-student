import 'package:flutter/material.dart';
import 'package:online_course/screens/account.dart';
import 'package:online_course/screens/announces.dart';
import 'package:online_course/screens/explore.dart';
import 'package:online_course/screens/home.dart';
import 'package:online_course/screens/my_courses.dart';
import 'package:online_course/theme/color.dart';

import '../utils/auth.dart';
import '../widgets/bottombar_box.dart';
import '../widgets/bottombar_item.dart'; // Import AuthService

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

  @override
  void initState() {
    super.initState();
    // Check if the user is authenticated
    if (!AuthService.isAuthenticated) {
      // If not, navigate to the login page
      Future.delayed(Duration.zero, () {
        Navigator.pushReplacementNamed(context, '/login');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthService.isAuthenticated
          ? _buildMainApp() // Show main app content if authenticated
          : Center(
              child:
                  CircularProgressIndicator()), // Show loading while checking
      bottomNavigationBar:
          AuthService.isAuthenticated ? _buildBottomBar() : null,
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
}
