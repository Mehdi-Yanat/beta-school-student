import 'package:flutter/material.dart';
import 'package:online_course/providers/auth_provider.dart';
import 'package:online_course/screens/account.dart';
import 'package:online_course/screens/announces.dart';
import 'package:online_course/screens/explore.dart';
import 'package:online_course/screens/home.dart';
import 'package:online_course/screens/my_courses.dart';
import 'package:online_course/theme/color.dart';
import 'package:provider/provider.dart';
import '../widgets/bottombar_box.dart';
import '../widgets/bottombar_item.dart';

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
  Widget build(BuildContext context) {
    // Listen to changes in the AuthProvider
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // If not authenticated, redirect to login
        if (!authProvider.isAuthenticated) {
          // Navigate to login screen
          Future.microtask(
              () => Navigator.pushReplacementNamed(context, '/login'));

          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // If authenticated, show the main app content
        return Scaffold(
          body: _buildMainApp(),
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
}
