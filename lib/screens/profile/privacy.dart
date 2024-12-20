import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import localization

import '../../theme/color.dart';
import '../../widgets/appbar.dart';

class PrivacyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBgColor,
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.privacy_title,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.security, color: AppColor.primary),
            title: Text(
              AppLocalizations.of(context)!.privacy_settings,
              style: TextStyle(color: AppColor.textColor),
            ),
            onTap: () {
              // Handle Privacy Settings tap
            },
          ),
          ListTile(
            leading: Icon(Icons.data_usage, color: AppColor.primary),
            title: Text(
              AppLocalizations.of(context)!.data_usage,
              style: TextStyle(color: AppColor.textColor),
            ),
            onTap: () {
              // Handle Data Usage tap
            },
          ),
          ListTile(
            leading: Icon(Icons.lock, color: AppColor.primary),
            title: Text(
              AppLocalizations.of(context)!.app_permissions,
              style: TextStyle(color: AppColor.textColor),
            ),
            onTap: () {
              // Handle App Permissions tap
            },
          ),
        ],
      ),
    );
  }
}
