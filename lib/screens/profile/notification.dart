import 'package:flutter/material.dart';

import '../../theme/color.dart';

class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBgColor,
      appBar: AppBar(
        title:
            Text('Notifications', style: TextStyle(color: AppColor.textColor)),
        backgroundColor: AppColor.appBarColor,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColor.textColor),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.notifications_active, color: AppColor.primary),
            title: Text('Push Notifications',
                style: TextStyle(color: AppColor.textColor)),
            onTap: () {
              // Handle Push Notifications tap
            },
          ),
          ListTile(
            leading: Icon(Icons.email, color: AppColor.primary),
            title: Text('Email Notifications',
                style: TextStyle(color: AppColor.textColor)),
            onTap: () {
              // Handle Email Notifications tap
            },
          ),
          ListTile(
            leading: Icon(Icons.sms, color: AppColor.primary),
            title: Text('SMS Notifications',
                style: TextStyle(color: AppColor.textColor)),
            onTap: () {
              // Handle SMS Notifications tap
            },
          ),
        ],
      ),
    );
  }
}
