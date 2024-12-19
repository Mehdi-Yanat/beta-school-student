import 'package:flutter/material.dart';
import 'package:online_course/theme/color.dart';
import '../../utils/auth.dart';
import '../../widgets/gradient_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

  void _signup() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    // Signup attempt
    bool success = await AuthService.signup(
      _nameController.text,
      _emailController.text,
      _passwordController.text,
    );

    setState(() {
      _isLoading = false;
      if (success) {
        Navigator.pushReplacementNamed(context, '/');
      } else {
        _errorMessage = 'Signup failed. Try again.';
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
                  'assets/logo.png', // Path to your logo
                  height: 80,
                  color: AppColor.primary,
                ),
              ),
              SizedBox(height: 20),

              // Header
              Text(
                'Create Account',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColor.primary,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Register to explore courses.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColor.textColor.withOpacity(0.7),
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 40),

              // Name Field
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Full Name',
                  prefixIcon: Icon(Icons.person, color: AppColor.textColor),
                  filled: true,
                  fillColor: AppColor.textBoxColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 16),

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
                  style: TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),

              // Signup Button
              SizedBox(height: 20),
              GradientButton(
                text: _isLoading ? 'Loading...' : 'Sign Up',
                variant: 'primary',
                color: Colors.white,
                disabled: _isLoading,
                onTap: _isLoading ? () => {} : _signup,
              ),
              SizedBox(height: 20),

              // Login Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have an account? ',
                      style: TextStyle(color: AppColor.textColor)),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/login'),
                    child: Text(
                      'Login',
                      style: TextStyle(color: AppColor.primary),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
