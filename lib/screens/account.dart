import 'package:flutter/material.dart';
import 'package:online_course/screens/profile/bookmark.dart';
import 'package:online_course/screens/profile/notification.dart';
import 'package:online_course/screens/profile/payments.dart';
import 'package:online_course/screens/profile/privacy.dart';
import 'package:online_course/screens/profile/settings.dart';
import 'package:online_course/theme/color.dart';
import 'package:online_course/utils/data.dart';
import 'package:online_course/widgets/custom_image.dart';
import 'package:online_course/widgets/setting_box.dart';
import 'package:online_course/widgets/setting_item.dart';

import '../utils/auth.dart';
import '../widgets/appbar.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(title: 'Account'),
        body: CustomScrollView(
          slivers: <Widget>[SliverToBoxAdapter(child: _buildBody(context))],
        ));
  }
}

Widget _buildBody(context) {
  return SingleChildScrollView(
    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
    child: Column(
      children: [
        _buildProfile(context),
        const SizedBox(
          height: 20,
        ),
        _buildRecord(context),
        const SizedBox(
          height: 20,
        ),
        _buildSection1(context),
        const SizedBox(
          height: 20,
        ),
        _buildSection2(context),
        const SizedBox(
          height: 20,
        ),
        _buildSection3(context),
      ],
    ),
  );
}

Widget _buildProfile(context) {
  return Column(
    children: [
      CustomImage(
        profile["image"]!,
        width: 70,
        height: 70,
        radius: 20,
      ),
      const SizedBox(
        height: 10,
      ),
      Text(
        profile["name"]!,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
    ],
  );
}

Widget _buildRecord(context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        child: SettingBox(
          title: "12 courses",
          icon: "assets/icons/work.svg",
        ),
      ),
      const SizedBox(
        width: 10,
      ),
      Expanded(
        child: SettingBox(
          title: "55 hours",
          icon: "assets/icons/time.svg",
        ),
      ),
      const SizedBox(
        width: 10,
      ),
      Expanded(
        child: SettingBox(
          title: "4.8",
          icon: "assets/icons/star.svg",
        ),
      ),
    ],
  );
}

Widget _buildSection1(context) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 15),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      color: AppColor.cardColor,
      boxShadow: [
        BoxShadow(
          color: AppColor.shadowColor.withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 1,
          offset: Offset(0, 1),
        ),
      ],
    ),
    child: Column(
      children: [
        SettingItem(
          title: "Setting",
          leadingIcon: "assets/icons/setting.svg",
          bgIconColor: AppColor.blue,
          onTap: () {
            // Navigate to Settings Page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingPage()),
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.only(left: 45),
          child: Divider(
            height: 0,
            color: Colors.grey.withOpacity(0.8),
          ),
        ),
        SettingItem(
          title: "Payment",
          leadingIcon: "assets/icons/wallet.svg",
          bgIconColor: AppColor.green,
          onTap: () {
            // Navigate to Payment Page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PaymentPage()),
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.only(left: 45),
          child: Divider(
            height: 0,
            color: Colors.grey.withOpacity(0.8),
          ),
        ),
        SettingItem(
          title: "Bookmark",
          leadingIcon: "assets/icons/bookmark.svg",
          bgIconColor: AppColor.primary,
          onTap: () {
            // Navigate to Bookmark Page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BookmarkPage()),
            );
          },
        ),
      ],
    ),
  );
}

Widget _buildSection2(context) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 15),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      color: AppColor.cardColor,
      boxShadow: [
        BoxShadow(
          color: AppColor.shadowColor.withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 1,
          offset: Offset(0, 1),
        ),
      ],
    ),
    child: Column(
      children: [
        SettingItem(
          title: "Notification",
          leadingIcon: "assets/icons/bell.svg",
          bgIconColor: AppColor.purple,
          onTap: () {
            // Navigate to Notification Page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NotificationPage()),
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.only(left: 45),
          child: Divider(
            height: 0,
            color: Colors.grey.withOpacity(0.8),
          ),
        ),
        SettingItem(
          title: "Privacy",
          leadingIcon: "assets/icons/shield.svg",
          bgIconColor: AppColor.orange,
          onTap: () {
            // Navigate to Privacy Page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PrivacyPage()),
            );
          },
        ),
      ],
    ),
  );
}

Widget _buildSection3(context) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 15),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      color: AppColor.cardColor,
      boxShadow: [
        BoxShadow(
          color: AppColor.shadowColor.withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 1,
          offset: Offset(0, 1),
        ),
      ],
    ),
    child: SettingItem(
      title: "Log Out",
      leadingIcon: "assets/icons/logout.svg",
      bgIconColor: AppColor.darker,
      onTap: () {
        // Log out the user
        AuthService.logout();

        // Redirect to the login page
        Navigator.pushReplacementNamed(context, '/login');
      },
    ),
  );
}
