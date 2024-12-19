import 'dart:ui'; // For BackdropFilter
import 'package:flutter/material.dart';

import '../theme/color.dart';

class CustomBottomBar extends StatelessWidget {
  final List<Widget> children;

  const CustomBottomBar({
    Key? key,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      // Ensure blur is constrained to the bottom bar
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(25),
        topRight: Radius.circular(25),
      ),
      child: BackdropFilter(
        filter:
            ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0), // Apply blur effect
        child: Container(
          height: 75,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF4318ff), // main
                Color(0xFF9f7aea), // state
              ],
              begin: Alignment(-0.97, -0.24), // approximates degree 97.89
              end: Alignment(0.97, 0.24),
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 25,
              right: 25,
              bottom: 15,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: children,
            ),
          ),
        ),
      ),
    );
  }
}
