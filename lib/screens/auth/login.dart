import 'package:flutter/material.dart';
import '../../utils/auth.dart';
import '../../theme/color.dart';
import '../../widgets/gradient_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

  void _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    // Attempt login
    bool success = await AuthService.login(
      _emailController.text,
      _passwordController.text,
    );

    setState(() {
      _isLoading = false;
      if (success) {
        Navigator.pushReplacementNamed(context, '/root');
      } else {
        // Fetch the localized string for "Invalid email or password"
        _errorMessage = AppLocalizations.of(context)!.invalid_credentials;
      }
    });
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
                child: Image.asset(
                  'assets/logo.png',
                  height: 80,
                  color: AppColor.primary,
                ),
              ),
              const SizedBox(height: 20),

              // Welcome Message
              Text(
                AppLocalizations.of(context)!.welcome_message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColor.primary,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!.sign_in_message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColor.textColor.withOpacity(0.7),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 40),

              // Email Field
              TextField(
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
              ),
              const SizedBox(height: 16),

              // Password Field
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.password_hint,
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

              // Error Message
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),

              // Login Button
              const SizedBox(height: 20),
              GradientButton(
                text: _isLoading
                    ? AppLocalizations.of(context)!.loading
                    : AppLocalizations.of(context)!.login_button,
                variant: 'primary',
                color: Colors.white,
                disabled: _isLoading,
                onTap: _isLoading ? () => {} : _login,
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
}
