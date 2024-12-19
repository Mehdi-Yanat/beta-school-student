import 'package:flutter/material.dart';
import 'package:online_course/theme/color.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _imageLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Preload the image and handle navigation
    _loadResourcesAndNavigate();
  }

  Future<void> _loadResourcesAndNavigate() async {
    try {
      // Preload app logo image
      await precacheImage(const AssetImage('assets/logo.png'), context);

      setState(() {
        _imageLoaded = true; // Update state once logo is loaded
      });

      // Wait for a few seconds showing splash screen
      await Future.delayed(const Duration(seconds: 360));

      // Navigate to Login Screen
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (error) {
      debugPrint('Error loading resources: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Centered Logo
          Expanded(
            child: Center(
              child: _imageLoaded
                  ? Image.asset(
                      'assets/logo.png', // App logo asset
                      height: 150,
                      color: AppColor.primary, // Optional tint
                    )
                  : const SizedBox(), // Empty space until image is loaded
            ),
          ),

          // Loading Spinner at the bottom
          const Padding(
            padding: EdgeInsets.only(bottom: 30.0),
            child: CircularProgressIndicator(
              color: AppColor.primary,
            ),
          ),
        ],
      ),
    );
  }
}
