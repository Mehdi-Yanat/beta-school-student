// For BackdropFilter
import 'package:flutter/material.dart';

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
      elevation: 8,
      backgroundColor: Colors.white.withValues(alpha: 0.9),
      // Transparent to show blur and gradient
      flexibleSpace: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(40),
            bottomRight: Radius.circular(40),
          ),
        ),
        // Ensure the blur effect is clipped to the AppBar's area
        child: Container(
            decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  spreadRadius: 5,
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
              gradient: LinearGradient(
                colors: [
                  Color(0xFF0075FF), // main
                  Color(0xFF21D4FD), // state
                ],
                begin: Alignment(
                    0.838, 0.546), // Start point shifted for 127 degrees
                end: Alignment(
                    -0.838, -0.546), // End point aligned for 127 degrees
              ),
            ),
            child: AppBar(
              title: title,
              elevation: 0,
              clipBehavior: Clip.none,
              backgroundColor: Colors.transparent, // Fully transparent
              automaticallyImplyLeading: false, // Remove the back arrow
            ),
          ),
        ),
    );
  }
}
