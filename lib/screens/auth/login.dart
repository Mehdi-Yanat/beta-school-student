import 'package:flutter/material.dart';
import 'package:online_course/theme/color.dart';
import '../../utils/auth.dart';

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
      _errorMessage = ''; // Clear error message
    });

    // Attempt login with the AuthService
    bool success = await AuthService.login(
      _emailController.text,
      _passwordController.text,
    );

    setState(() {
      _isLoading = false;
      if (success) {
        // Navigate to the home screen or main app page
        Navigator.pushReplacementNamed(context, '/');
      } else {
        _errorMessage = 'Invalid email or password.';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBgColor,
      appBar: AppBar(
        title: Text('Login', style: TextStyle(color: AppColor.textColor)),
        backgroundColor: AppColor.appBarColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(
          children: [
            SizedBox(height: 40),
            Text('Welcome back!',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColor.textColor)),
            SizedBox(height: 10),
            Text('Please sign in to continue.',
                style: TextStyle(color: AppColor.textColor.withOpacity(0.7))),
            SizedBox(height: 40),
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
            // Only show the loading spinner if _isLoading is true
            if (_isLoading)
              Center(
                child: CircularProgressIndicator(),
              ),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed:
                  _isLoading ? null : _login, // Disable button during loading
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primary,
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: Text('Login', style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Don\'t have an account?',
                    style: TextStyle(color: AppColor.textColor)),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                  child: Text('Sign up',
                      style: TextStyle(color: AppColor.primary)),
                ),
              ],
            ),
            SizedBox(height: 20),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/forget-password');
                },
                child: Text('Forgot Password?',
                    style: TextStyle(color: AppColor.primary)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
