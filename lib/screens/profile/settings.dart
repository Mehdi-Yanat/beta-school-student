import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import localization
import 'package:online_course/screens/profile/update_profile.dart';
import '../../main.dart';
import '../../theme/color.dart';
import '../../widgets/appbar.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  // Define the default locale
  Locale _currentLocale = Locale('fr'); // Default is French

  // Function to switch the selected language and notify the app
  void _setLanguage(Locale locale) {
    setState(() {
      _currentLocale = locale; // Update locale
    });
    MyApp.currentLocale.value = locale; // Notify the app
  }

  // Function to show the language selection dialog
  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.select_language),
          content: Column(
            mainAxisSize: MainAxisSize.min, // Keep dialog content compact
            children: [
              ListTile(
                leading: Icon(
                  Icons.language,
                  color: _currentLocale.languageCode == 'fr'
                      ? AppColor.primary
                      : Colors.black,
                ),
                title: Text(AppLocalizations.of(context)!.language_french),
                onTap: () {
                  _setLanguage(Locale('fr')); // Switch to French
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.language,
                  color: _currentLocale.languageCode == 'ar'
                      ? AppColor.primary
                      : Colors.black,
                ),
                title: Text(AppLocalizations.of(context)!.language_arabic),
                onTap: () {
                  _setLanguage(Locale('ar')); // Switch to Arabic
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBgColor,
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.settings_title,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.account_circle, color: AppColor.primary),
            title: Text(
              AppLocalizations.of(context)!.settings_profile,
              style: TextStyle(color: AppColor.mainColor),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>  UpdateProfileScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.security, color: AppColor.primary),
            title: Text(
              AppLocalizations.of(context)!.settings_security,
              style: TextStyle(color: AppColor.mainColor),
            ),
            onTap: () {
              // Handle Security tap
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications, color: AppColor.primary),
            title: Text(
              AppLocalizations.of(context)!.settings_notifications,
              style: TextStyle(color: AppColor.mainColor),
            ),
            onTap: () {
              // Handle Notifications tap
            },
          ),
          const Divider(),
          // Language Selection ListTile
          ListTile(
            leading: Icon(Icons.language, color: AppColor.primary),
            title: Text(
              AppLocalizations.of(context)!.change_language,
              style: TextStyle(color: AppColor.mainColor),
            ),
            trailing: Icon(Icons.arrow_forward_ios, color: AppColor.mainColor),
            onTap: () {
              _showLanguageDialog(
                  context); // Show dialog for language selection
            },
          ),
        ],
      ),
    );
  }
}
