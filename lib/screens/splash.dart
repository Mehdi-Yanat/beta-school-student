import 'package:flutter/material.dart';
import 'package:online_course/theme/color.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _imageLoaded = false;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller for fading effect
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1), // Animation duration for fade-in
    );

    // Define the fade animation
    _fadeAnimation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Preload logo and manage transition
    _loadResourcesAndAnimate();
  }

  Future<void> _loadResourcesAndAnimate() async {
    try {
      // Preload the logo to prevent delays
      await precacheImage(const AssetImage('assets/logo.png'), context);

      // Indicate that the image has been loaded
      setState(() {
        _imageLoaded = true;
      });

      // Start the fade-in animation
      _animationController.forward();

      // Keep splash screen for a few seconds
      await Future.delayed(const Duration(seconds: 3));

      // Navigate to the next screen
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (error) {
      debugPrint('Error loading resources: $error');
    }
  }

  @override
  void dispose() {
    // Dispose the animation controller
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Fade-in animation for the logo
          Expanded(
            child: Center(
              child: FadeTransition(
                opacity: _imageLoaded
                    ? _fadeAnimation
                    : const AlwaysStoppedAnimation(0.0),
                child: _imageLoaded
                    ? Image.asset(
                        'assets/logo.png',
                        height: 150, // Logo size
                        color: AppColor.primary, // Optional tint
                      )
                    : const SizedBox(),
              ),
            ),
          ),

          // Spinner at the bottom of the screen
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
