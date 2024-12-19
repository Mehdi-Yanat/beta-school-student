import 'package:flutter/material.dart';
import 'package:online_course/theme/color.dart';
import '../../utils/auth.dart';
import '../../widgets/gradient_button.dart';

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
        _errorMessage = 'Invalid email or password.';
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
              SizedBox(height: 40),

              // Logo
              Center(
                child: Image.asset(
                  'assets/logo.png', // Path to your logo in the assets folder
                  height: 80,
                  color: AppColor.primary,
                ),
              ),
              SizedBox(height: 20),

              // Welcome Message
              Text(
                'Welcome Back!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColor.primary,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Sign in to access your courses.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColor.textColor.withOpacity(0.7),
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 40),

              // Email Field
              TextField(
                controller: _emailController,
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
              SizedBox(height: 16),

              // Password Field
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  hintText: 'Password',
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

              // Error Message
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),

              // Login Button
              SizedBox(height: 20),
              GradientButton(
                text: _isLoading ? 'Loading...' : 'Login',
                variant: 'primary',
                color: Colors.white,
                disabled: _isLoading,
                onTap: _isLoading ? () => {} : _login,
              ),
              SizedBox(height: 20),

              // Signup and Forgot Password
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Don\'t have an account? ',
                    style: TextStyle(color: AppColor.textColor),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/signup'),
                    child: Text(
                      'Sign up',
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
                    'Forgot Password?',
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
