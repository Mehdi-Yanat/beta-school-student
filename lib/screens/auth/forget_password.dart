import 'package:flutter/material.dart';
import 'package:online_course/theme/color.dart';

import '../../widgets/appbar.dart';
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
            SizedBox(height: 40),

            // Logo Section
            Center(
              child: Image.asset(
                'assets/logo.png', // Path to the app's logo
                height: 80,
                color: AppColor.primary, // Tint the logo if necessary
              ),
            ),
            SizedBox(height: 20),

            // Forgot Password Text
            Text(
              'Forgot your password?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColor.primary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              'Enter your email to reset your password.',
              style: TextStyle(
                color: AppColor.textColor.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),

            // Email Address Field
            TextField(
              decoration: InputDecoration(
                hintText: 'Email Address',
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
            SizedBox(height: 20),

            // Submit Button
            GradientButton(
              text: 'Submit',
              variant: 'primary',
              color: Colors.white,
              disabled: false,
              onTap: _forgetPassword,
            ),
            SizedBox(height: 20),

            // Back to Login Button
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: Text(
                  'Back to Login',
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
