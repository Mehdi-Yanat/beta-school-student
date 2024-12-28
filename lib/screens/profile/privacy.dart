import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import localization
import 'package:online_course/screens/profile/privacy/data.dart';

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
              leading: Icon(Icons.data_usage, color: AppColor.primary),
              title: Text(
                AppLocalizations.of(context)!.data_usage,
                style: TextStyle(color: AppColor.mainColor),
              ),
              onTap: () {
                // Handle Data Usage tap
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PrivacyPolicyPage()));
              }),
        ],
      ),
    );
  }
}
