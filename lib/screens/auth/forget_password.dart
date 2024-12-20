import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import localization
import 'package:online_course/theme/color.dart';

import '../../widgets/gradient_button.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  void _forgetPassword() {
    print("Forget Password Clicked");
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
                color: AppColor.primary, // Tint the logo if necessary
              ),
            ),
            const SizedBox(height: 20),

            // Forgot Password Text
            Text(
              AppLocalizations.of(context)!.forgot_password_title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColor.primary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              AppLocalizations.of(context)!.forgot_password_subtitle,
              style: TextStyle(
                color: AppColor.textColor.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            // Email Address Field
            TextField(
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.email_hint,
                prefixIcon: Icon(Icons.email, color: AppColor.textColor),
                filled: true,
                fillColor: AppColor.textBoxColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),

            // Submit Button
            GradientButton(
              text: AppLocalizations.of(context)!.submit_button,
              variant: 'primary',
              color: Colors.white,
              disabled: false,
              onTap: _forgetPassword,
            ),
            const SizedBox(height: 20),

            // Back to Login Button
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: Text(
                  AppLocalizations.of(context)!.back_to_login,
                  style: TextStyle(color: AppColor.primary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
