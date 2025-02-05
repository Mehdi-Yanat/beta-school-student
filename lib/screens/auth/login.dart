import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:online_course/providers/auth_provider.dart';
import 'package:online_course/widgets/snackbar.dart';
import 'package:provider/provider.dart';
import '../../theme/color.dart';
import '../../widgets/gradient_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _passwordVisible = false;

  void _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      final result = await authProvider.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (mounted) {
        if (result.success) {
          SnackBarHelper.showSuccessSnackBar(
              context, AppLocalizations.of(context)!.login_success);
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/root',
            (Route<dynamic> route) => false,
          );
        } else {
          SnackBarHelper.showErrorSnackBar(context, result.message);
        }
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: ListView(
            children: [
              const SizedBox(height: 40),

              // Logo
              Center(
                child: SvgPicture.asset(
                  'assets/icons/logo-v2-gradient.svg',
                  // height: 80,
                  width: 100,
                ),
              ),
              const SizedBox(height: 20),

              // Welcome Message
              Text(
                AppLocalizations.of(context)!.welcome_message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w400,
                  color: AppColor.darker,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!.sign_in_message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColor.textColor.withValues(alpha: 1),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 40),

              // Form with validation
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Email Field
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.email_hint,
                        prefixIcon:
                            Icon(Icons.email, color: AppColor.textColor),
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
                    const SizedBox(height: 16),

                    // Password Field
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.password_hint,
                        prefixIcon: Icon(Icons.lock, color: AppColor.textColor),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey, // Adjust color as needed
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordVisible =
                                  !_passwordVisible; // Toggle visibility
                            });
                          },
                        ),
                        filled: true,
                        fillColor: AppColor.textBoxColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      obscureText: !_passwordVisible,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context)!
                              .password_required;
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Login Button
              const SizedBox(height: 20),
              GradientButton(
                text: _isLoading
                    ? AppLocalizations.of(context)!.loading
                    : AppLocalizations.of(context)!.login_button,
                variant: 'blueGradient',
                disabled: _isLoading,
                onTap: _login,
                color: AppColor.primary,
              ),
              const SizedBox(height: 20),

              // Signup and Forgot Password
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.no_account_text,
                    style: TextStyle(color: AppColor.textColor),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/signup'),
                    child: Text(
                      AppLocalizations.of(context)!.signup_button,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColor.primary,
                      ),
                    ),
                  ),
                ],
              ),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/forget-password');
                  },
                  child: Text(
                    AppLocalizations.of(context)!.forgot_password,
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
