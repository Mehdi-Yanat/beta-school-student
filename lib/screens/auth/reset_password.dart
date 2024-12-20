import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import localization
import 'package:online_course/theme/color.dart';

import '../../widgets/gradient_button.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  void _resetPassword() {
    // Add reset password business logic here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBgColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(
          children: [
            const SizedBox(height: 40),

            // Logo Section
            Center(
              child: Image.asset(
                'assets/logo.png', // Path to the app's logo
                height: 80,
                color: AppColor.primary, // Tint the logo if needed
              ),
            ),
            const SizedBox(height: 20),

            // Reset Password Text
            Text(
              AppLocalizations.of(context)!.reset_password_title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColor.mainColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              AppLocalizations.of(context)!.reset_password_subtitle,
              style: TextStyle(
                color: AppColor.textColor.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            // New Password Field
            TextField(
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.new_password_hint,
                prefixIcon: Icon(Icons.lock, color: AppColor.textColor),
                filled: true,
                fillColor: AppColor.textBoxColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),

            // Confirm Password Field
            TextField(
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.confirm_password_hint,
                prefixIcon: Icon(Icons.lock, color: AppColor.textColor),
                filled: true,
                fillColor: AppColor.textBoxColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),

            // Submit Button
            GradientButton(
              text: AppLocalizations.of(context)!.submit_button,
              variant: 'primary',
              color: Colors.white,
              disabled: false,
              onTap: _resetPassword,
            ),
          ],
        ),
      ),
    );
  }
}
