import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:online_course/services/auth_service.dart';
import 'package:online_course/theme/color.dart';
import 'package:online_course/widgets/snackbar.dart';
import '../../widgets/gradient_button.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String token;
  const ResetPasswordScreen({super.key, required this.token});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      print("ResetPasswordScreen token: ${widget.token}");

      final result = await AuthService.resetPassword(
        widget.token,
        _passwordController.text,
      );

      if (result.success) {
        if (mounted) {
          SnackBarHelper.showSuccessSnackBar(
            context,
            AppLocalizations.of(context)!.password_reset_success,
          );
          Navigator.pushReplacementNamed(context, '/login');
        }
      } else {
        setState(() => _errorMessage = result.message);
        SnackBarHelper.showErrorSnackBar(context, result.message);
      }
    } catch (e) {
      setState(() => _errorMessage = e.toString());
      SnackBarHelper.showErrorSnackBar(context, e.toString());
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
                  color: AppColor.primary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!.reset_password_subtitle,
                style: TextStyle(
                  color: AppColor.textColor.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // New Password Field
              TextFormField(
                controller: _passwordController,
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.password_required;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Confirm Password Field
              TextFormField(
                controller: _confirmPasswordController,
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!
                        .confirm_password_required;
                  }
                  if (value != _passwordController.text) {
                    return AppLocalizations.of(context)!.passwords_do_not_match;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Submit Button
              GradientButton(
                text: _isLoading
                    ? AppLocalizations.of(context)!.loading
                    : AppLocalizations.of(context)!.submit_button,
                variant: 'primary',
                color: Colors.white,
                disabled: _isLoading,
                onTap: _resetPassword,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
