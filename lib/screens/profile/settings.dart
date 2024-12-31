import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import localization
import 'package:online_course/screens/profile/settings/security.dart';
import 'package:online_course/screens/profile/settings/update_profile.dart';
import 'package:online_course/services/auth_service.dart';
import 'package:online_course/widgets/snackbar.dart';
import '../../main.dart' show MyApp;
import '../../theme/color.dart';
import '../../widgets/appbar.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  // Define the default locale
  late Locale _currentLocale;

  @override
  void initState() {
    super.initState();
    _currentLocale = MyApp.currentLocale.value;
  }

  // Function to switch the selected language and notify the app
  void _setLanguage(Locale locale) {
    setState(() {
      _currentLocale = locale;
    });
    MyApp.currentLocale.value = locale;
  }

  // Function to show the language selection dialog
  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.select_language),
          content: Column(
            mainAxisSize: MainAxisSize.min,
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
                  _setLanguage(Locale('fr'));
                  Navigator.of(context).pop();
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
                  _setLanguage(Locale('ar'));
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteAccountDialog() {
    final TextEditingController nameController = TextEditingController();
    final accountName =
        "YourAccountName"; // Replace with the actual account name

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            AppLocalizations.of(context)!.delete_account_title,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.of(context)!.delete_account_message,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.enter_account_name,
                  hintText: accountName,
                  // Show the correct account name as a hint
                  border: const OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text(AppLocalizations.of(context)!.cancel_button),
            ),
            TextButton(
              onPressed: () {
                // Validate user input
                if (nameController.text.trim() == accountName) {
                  // If the user enters the correct name, proceed with deletion
                  AuthService.deleteAccount().then((value) {
                    if (value) {
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/login', (route) => false);
                      SnackBarHelper.showSuccessSnackBar(
                        context,
                        AppLocalizations.of(context)!.delete_account_success,
                      );
                    } else {
                      SnackBarHelper.showErrorSnackBar(
                        context,
                        AppLocalizations.of(context)!.delete_account_error,
                      );
                    }
                  });
                } else {
                  // If the input is incorrect, show an error snackbar
                  SnackBarHelper.showErrorSnackBar(
                    context,
                    AppLocalizations.of(context)!.delete_account_name_error,
                  );
                }
              },
              child: Text(AppLocalizations.of(context)!.delete_button),
            ),
          ],
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
                      builder: (context) => UpdateProfileScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.security, color: AppColor.primary),
            title: Text(
              AppLocalizations.of(context)!.settings_security,
              style: TextStyle(color: AppColor.mainColor),
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SecurityScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.delete_forever, color: Colors.red),
            title: Text(
              AppLocalizations.of(context)!.delete_account,
              style: TextStyle(color: Colors.red),
            ),
            onTap: _showDeleteAccountDialog,
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
