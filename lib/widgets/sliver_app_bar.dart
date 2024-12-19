import 'dart:ui'; // For BackdropFilter
import 'package:flutter/material.dart';

import '../theme/color.dart';

class CustomSliverAppBar extends StatelessWidget {
  final Widget title;
  final double toolbarHeight;
  final bool pinned;
  final bool snap;
  final bool floating;

  const CustomSliverAppBar({
    Key? key,
    required this.title,
    this.toolbarHeight = kToolbarHeight,
    this.pinned = false,
    this.snap = false,
    this.floating = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: pinned,
      snap: snap,
      floating: floating,
      toolbarHeight: toolbarHeight,
      elevation: 0,
      backgroundColor: Colors.transparent,
      // Transparent to show blur and gradient
      flexibleSpace: ClipRRect(
        // Ensure the blur effect is clipped to the AppBar's area
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0), // Apply blur
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF4318ff), // main
                  Color(0xFF9f7aea), // state
                ],
                begin: Alignment(-0.97, -0.24), // approximates degree 97.89
                end: Alignment(0.97, 0.24),
              ),
            ),
            child: AppBar(
              title: title,
              elevation: 0,
              backgroundColor: Colors.transparent, // Fully transparent
            ),
          ),
        ),
      ),
    );
  }
}
