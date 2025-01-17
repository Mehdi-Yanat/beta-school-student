import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:online_course/theme/gradients.dart';

import '../theme/color.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  int _currentPage = 0; // Tracks the currently visible page

  late AnimationController _animationController;
  late Animation<Offset> _svgAnimation;
  late Animation<double> _fadeInAnimation;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(initialPage: 0);

    // Initialize Animation Controller for the first page animation
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Setup the animations for the first onboarding page:
    // Slide the SVG from the bottom to the center
    _svgAnimation = Tween<Offset>(
      begin: const Offset(0, 2), // Start offscreen (below)
      end: Offset.zero, // End at the center
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    // Fade in the text and button
    _fadeInAnimation = Tween<double>(
      begin: 0, // Fully transparent
      end: 1, // Fully visible
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.5, 1.0,
          curve: Curves.easeIn), // Fade in after SVG reaches center
    ));

    // Start the animation when the screen initializes
    _animationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      _buildAnimatedPage(), // First page with slide/fade animation
      _buildPage(
        isImage: true,
        asset: "assets/images/learn-anytime.png",
        title: AppLocalizations.of(context)!.learn_anytime_anywhere,
        description: AppLocalizations.of(context)!
            .access_ressources_at_your_fingerprints,
      ),
      _buildPage(
        isImage: true,
        asset: "assets/images/join_now.png",
        title: AppLocalizations.of(context)!.learn_at_your_pace,
        description: AppLocalizations.of(context)!.you_can_learn_at_any_pace,
        isLastPage: true,
      ),
    ];

    return Scaffold(
      backgroundColor: AppColor.darkBackground,
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (int index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: pages.length,
              itemBuilder: (context, index) {
                return pages[index];
              },
            ),
          ),
          _buildPageIndicators(pages.length),
        ],
      ),
    );
  }

  Widget _buildAnimatedPage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SlideTransition(
          position: _svgAnimation, // Animate SVG movement
          child: SvgPicture.asset(
            "assets/icons/logo-v2-gradient.svg",
            width: 200,
          ),
        ),
        const SizedBox(height: 20),
        FadeTransition(
          opacity: _fadeInAnimation, // Fade in animation for text
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Image.asset(
                "assets/icons/logo-large.png",
                width: 200,
              ),
              Positioned(
                top: 10,
                right: -50,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: AppGradients.blueGradient,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    textDirection: TextDirection.ltr,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "online",
                        style: TextStyle(
                          fontFamily: 'Rubik',
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 10),
        FadeTransition(
          opacity: _fadeInAnimation, // Fade in animation for text
          child: Text(
            AppLocalizations.of(context)!.new_welcome_message,
            style: const TextStyle(
              fontSize: 35,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 18),
        FadeTransition(
          opacity: _fadeInAnimation, // Fade in animation for subtext
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              AppLocalizations.of(context)!.start_your_learning_journey,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPage({
    required String asset,
    required bool isImage,
    required String title,
    required String description,
    bool isLastPage = false,
  }) {
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isImage
                ? Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: AppColor.appBgColor),
                    child: Image.asset(
                      asset,
                      width: 300,
                    ))
                : SvgPicture.asset(
                    asset,
                    width: 200,
                  ),
            const SizedBox(height: 30),
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                description,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
        if (isLastPage)
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primary,
                padding: const EdgeInsets.symmetric(
                    horizontal: 40.0, vertical: 15.0),
                textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              onPressed: () {
                // Navigate to login
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: Text(
                AppLocalizations.of(context)!.start_learning_now,
                style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Rubik',
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          )
      ],
    );
  }

  Widget _buildPageIndicators(int numPages) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(numPages, (index) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            height: 10,
            width: _currentPage == index ? 20 : 10,
            decoration: BoxDecoration(
              color:
                  _currentPage == index ? AppColor.brandFocus : Colors.white70,
              borderRadius: BorderRadius.circular(5),
            ),
          );
        }),
      ),
    );
  }
}
