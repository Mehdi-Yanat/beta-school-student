import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import localization
import 'package:online_course/models/student.dart';
import 'package:online_course/providers/auth_provider.dart';
import 'package:online_course/screens/profile/bookmark.dart';
import 'package:online_course/screens/profile/notification.dart';
import 'package:online_course/screens/profile/payments.dart';
import 'package:online_course/screens/profile/privacy.dart';
import 'package:online_course/screens/profile/settings.dart';
import 'package:online_course/theme/color.dart';
import 'package:online_course/utils/data.dart';
import 'package:online_course/utils/logger.dart';
import 'package:online_course/widgets/custom_image.dart';
import 'package:online_course/widgets/setting_box.dart';
import 'package:online_course/widgets/setting_item.dart';
import 'package:provider/provider.dart';

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
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        final student = authProvider.student;
        Logger.log(
            'Current student: ${student!.email}'); // Replace print with Logger
        return Scaffold(
          appBar: CustomAppBar(
            title: AppLocalizations.of(context)!.account_title,
          ),
          body: CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: _buildBody(context, student),
              )
            ],
          ),
        );
      },
    );
  }
}

Widget _buildBody(context, Student? student) {
  return SingleChildScrollView(
    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
    child: Column(
      children: [
        _buildProfile(context, student),
        const SizedBox(
          height: 20,
        ),
        _buildRecord(context, student),
        const SizedBox(
          height: 20,
        ),
        _buildSection1(context, student),
        const SizedBox(
          height: 20,
        ),
        _buildSection2(context, student),
        const SizedBox(
          height: 20,
        ),
        _buildSection3(context, student),
      ],
    ),
  );
}

Widget _buildProfile(context, Student? student) {
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
        profile["name"]!, // User's name (static data)
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
    ],
  );
}

Widget _buildRecord(context, Student? student) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        child: SettingBox(
          title: AppLocalizations.of(context)!.account_courses,
          // Localized text
          icon: "assets/icons/work.svg",
        ),
      ),
      const SizedBox(
        width: 10,
      ),
      Expanded(
        child: SettingBox(
          title: AppLocalizations.of(context)!.account_hours, // Localized text
          icon: "assets/icons/time.svg",
        ),
      ),
      const SizedBox(
        width: 10,
      ),
      Expanded(
        child: SettingBox(
          title: AppLocalizations.of(context)!.account_rating, // Localized text
          icon: "assets/icons/star.svg",
        ),
      ),
    ],
  );
}

Widget _buildSection1(context, Student? student) {
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
          title: AppLocalizations.of(context)!.settings_title, // Localized text
          leadingIcon: "assets/icons/setting.svg",
          bgIconColor: AppColor.blue,
          onTap: () {
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
          title: AppLocalizations.of(context)!.payments_title, // Localized text
          leadingIcon: "assets/icons/wallet.svg",
          bgIconColor: AppColor.green,
          onTap: () {
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
          title: AppLocalizations.of(context)!.bookmark_title, // Localized text
          leadingIcon: "assets/icons/bookmark.svg",
          bgIconColor: AppColor.primary,
          onTap: () {
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

Widget _buildSection2(context, Student? student) {
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
          title: AppLocalizations.of(context)!.notifications_title,
          // Localized text
          leadingIcon: "assets/icons/bell.svg",
          bgIconColor: AppColor.purple,
          onTap: () {
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
          title: AppLocalizations.of(context)!.privacy_title, // Localized text
          leadingIcon: "assets/icons/shield.svg",
          bgIconColor: AppColor.orange,
          onTap: () {
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

Widget _buildSection3(context, Student? student) {
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
      title: AppLocalizations.of(context)!.account_logout, // Localized text
      leadingIcon: "assets/icons/logout.svg",
      bgIconColor: AppColor.darker,
      onTap: () {
        AuthService.logout();
        Navigator.pushReplacementNamed(context, '/login');
      },
    ),
  );
}
