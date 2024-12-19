import 'package:flutter/material.dart';
import 'package:online_course/theme/color.dart';

import '../../widgets/appbar.dart';
import '../../widgets/gradient_button.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  void _resetPassword() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBgColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(
          children: [
            SizedBox(height: 40),

            // Logo Section
            Center(
              child: Image.asset(
                'assets/logo.png', // Path to the app's logo
                height: 80,
                color: AppColor.primary, // Tint the logo if needed
              ),
            ),
            SizedBox(height: 20),

            // Reset Password Text
            Text(
              'Reset your password',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColor.mainColor,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              'Enter your new password below.',
              style: TextStyle(
                color: AppColor.textColor.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),

            // New Password Field
            TextField(
              decoration: InputDecoration(
                hintText: 'New Password',
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
            SizedBox(height: 16),

            // Confirm Password Field
            TextField(
              decoration: InputDecoration(
                hintText: 'Confirm Password',
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
            SizedBox(height: 20),

            // Submit Button
            GradientButton(
              text: 'Submit',
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
