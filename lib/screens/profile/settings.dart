import 'package:flutter/material.dart';
import '../../theme/color.dart';

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBgColor,
      appBar: AppBar(
        title: Text('Settings', style: TextStyle(color: AppColor.textColor)),
        backgroundColor: AppColor.appBarColor,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.account_circle, color: AppColor.primary),
            title: Text('Profile', style: TextStyle(color: AppColor.textColor)),
            onTap: () {
              // Handle Profile tap
            },
          ),
          ListTile(
            leading: Icon(Icons.security, color: AppColor.primary),
            title:
                Text('Security', style: TextStyle(color: AppColor.textColor)),
            onTap: () {
              // Handle Security tap
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications, color: AppColor.primary),
            title: Text('Notifications',
                style: TextStyle(color: AppColor.textColor)),
            onTap: () {
              // Handle Notifications tap
            },
          ),
        ],
      ),
    );
  }
}
