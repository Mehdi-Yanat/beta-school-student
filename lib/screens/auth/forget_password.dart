import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import localization
import 'package:online_course/services/auth_service.dart';
import 'package:online_course/theme/color.dart';

import '../../widgets/gradient_button.dart';
import '../../widgets/snackbar.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  Timer? _cooldownTimer;
  int _cooldownSeconds = 0;

  @override
  void dispose() {
    _emailController.dispose();
    _cooldownTimer?.cancel();
    super.dispose();
  }

  void _startCooldown() {
    _cooldownSeconds = 60; // 1 minute cooldown
    _cooldownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_cooldownSeconds > 0) {
          _cooldownSeconds--;
        } else {
          _cooldownTimer?.cancel();
        }
      });
    });
  }

  Future<void> _forgetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    // Check cooldown
    if (_cooldownSeconds > 0) {
      // Use reusable SnackBar for cooldown message
      SnackBarHelper.showErrorSnackBar(
        context,
        AppLocalizations.of(context)!.wait_before_retry,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final locale = Localizations.localeOf(context).languageCode;
      final success = await AuthService.forgotPassword(
        _emailController.text,
        lang: locale,
      );

      if (success) {
        if (mounted) {
          _startCooldown(); // Start cooldown timer
          // Use reusable SnackBar for success feedback
          SnackBarHelper.showSuccessSnackBar(
            context,
            AppLocalizations.of(context)!.reset_link_sent,
          );
        }
      }
    } catch (e) {
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBgColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
          key: _formKey,
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
                  color: AppColor.textColor.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              TextFormField(
                controller: _emailController,
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.email_required;
                  }
                  if (!value.contains('@')) {
                    return AppLocalizations.of(context)!.email_invalid;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              GradientButton(
                text: _isLoading
                    ? AppLocalizations.of(context)!.loading
                    : _cooldownSeconds > 0
                        ? AppLocalizations.of(context)!
                            .retry_in(_cooldownSeconds)
                        : AppLocalizations.of(context)!.submit_button,
                variant: 'primary',
                color: Colors.white,
                disabled: _isLoading || _cooldownSeconds > 0,
                onTap: _forgetPassword,
              ),

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
      ),
    );
  }
}
