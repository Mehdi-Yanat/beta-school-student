import 'package:flutter/material.dart';

import '../../theme/color.dart';
import '../../widgets/appbar.dart';

class PrivacyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBgColor,
      appBar: const CustomAppBar(title: 'Privacy'),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.security, color: AppColor.primary),
            title: Text('Privacy Settings',
                style: TextStyle(color: AppColor.textColor)),
            onTap: () {
              // Handle Privacy Settings tap
            },
          ),
          ListTile(
            leading: Icon(Icons.data_usage, color: AppColor.primary),
            title:
                Text('Data Usage', style: TextStyle(color: AppColor.textColor)),
            onTap: () {
              // Handle Data Usage tap
            },
          ),
          ListTile(
            leading: Icon(Icons.lock, color: AppColor.primary),
            title: Text('App Permissions',
                style: TextStyle(color: AppColor.textColor)),
            onTap: () {
              // Handle App Permissions tap
            },
          ),
        ],
      ),
    );
  }
}
