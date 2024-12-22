import 'package:flutter/material.dart';
import 'package:online_course/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import '../theme/color.dart';

class SplashScreen extends StatefulWidget {
  final Locale locale;
  const SplashScreen(this.locale, {super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _imageLoaded = false;

  @override
  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _fadeAnimation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn);

    // Schedule auth check after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuth();
    });
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
      final image = const AssetImage('assets/logo.png');
      await precacheImage(image, context);

      // Indicate that the image has been loaded
      setState(() {
        _imageLoaded = true;
      });

      // Start the fade-in animation
      _animationController.forward();
    } catch (error) {
      print('Error loading image: $error');
    }
  }

  Future<void> _checkAuth() async {
    try {
      await _loadResourcesAndAnimate();

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await Future.wait([
        authProvider.initAuth(),
        Future.delayed(const Duration(seconds: 2)),
      ]);

      if (!mounted) return;

      if (authProvider.isAuthenticated) {
        Navigator.pushReplacementNamed(context, '/root');
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      print('Auth check error: $e');
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
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
          Expanded(
            child: Center(
              child: FadeTransition(
                opacity: _imageLoaded
                    ? _fadeAnimation
                    : const AlwaysStoppedAnimation(0.0),
                child: _imageLoaded
                    ? Image.asset(
                        'assets/logo.png',
                        height: 150,
                        color: AppColor.primary,
                      )
                    : const SizedBox(),
              ),
            ),
          ),
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
