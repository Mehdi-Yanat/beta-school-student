import 'package:flutter/material.dart';
import 'dart:ui';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool centerTitle;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.centerTitle = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight), // AppBar height
      child: ClipRRect(
        // Ensures blur effect is clipped to the AppBar's area
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // Apply blur
          child: AppBar(
            title: Text(
              title,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 25),
            ),
            centerTitle: centerTitle,
            backgroundColor: Colors.black.withValues(alpha: 0.5),
            // Semi-transparent
            elevation: 0,
            automaticallyImplyLeading: false, // Removed back arrow
            actions: actions,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                colors: [
                  Color(0xFF0075FF), // main
                  Color(0xFF21D4FD), // state
                ],
                begin: Alignment(
                    0.838, 0.546), // Start point shifted for 127 degrees
                end: Alignment(
                    -0.838, -0.546), // End point aligned for 127 degrees
              )),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
