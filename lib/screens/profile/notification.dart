import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import localization

import '../../theme/color.dart';
import '../../widgets/appbar.dart';

class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBgColor,
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.notifications_title,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.notifications_active, color: AppColor.primary),
            title: Text(
              AppLocalizations.of(context)!.push_notifications,
              style: TextStyle(color: AppColor.textColor),
            ),
            onTap: () {
              // Handle Push Notifications tap
            },
          ),
          ListTile(
            leading: Icon(Icons.email, color: AppColor.primary),
            title: Text(
              AppLocalizations.of(context)!.email_notifications,
              style: TextStyle(color: AppColor.textColor),
            ),
            onTap: () {
              // Handle Email Notifications tap
            },
          ),
          ListTile(
            leading: Icon(Icons.sms, color: AppColor.primary),
            title: Text(
              AppLocalizations.of(context)!.sms_notifications,
              style: TextStyle(color: AppColor.textColor),
            ),
            onTap: () {
              // Handle SMS Notifications tap
            },
          ),
        ],
      ),
    );
  }
}
