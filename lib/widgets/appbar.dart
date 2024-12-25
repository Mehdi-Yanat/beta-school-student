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
              style: const TextStyle(color: Colors.white),
            ),
            centerTitle: centerTitle,
            backgroundColor: Colors.black.withValues(alpha: 0.5),
            // Semi-transparent
            elevation: 0,
            actions: actions,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                colors: [
                  Color(0xFF4318ff), // main
                  Color(0xFF9f7aea), // state
                ],
                begin: Alignment(-0.97, -0.24), // approximates degree 97.89
                end: Alignment(0.97, 0.24),
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
