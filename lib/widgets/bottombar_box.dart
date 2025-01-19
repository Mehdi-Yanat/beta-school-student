// For BackdropFilter
import 'package:flutter/material.dart';
import 'package:online_course/theme/color.dart';

class CustomBottomBar extends StatelessWidget {
  final List<Widget> children;

  const CustomBottomBar({
    Key? key,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // Add shadow to the entire Stack
        boxShadow: [
          BoxShadow(
            color: Colors.grey
                .withValues(alpha: 0.2), // Shadow color with transparency
            blurRadius: 20, // Blurry edges of the shadow
            spreadRadius: 5, // Spread the shadow slightly
            offset: Offset(0, -4), // Shadow offset (upward)
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
            ),
            child: Container(
              height: 90,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColor.appBgColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
            ),
          ),
          Positioned.fill(
              child: Padding(
            padding: const EdgeInsets.only(
              left: 25,
              right: 25,
              bottom: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: children,
            ),
          ))
        ],
      ),
    );
  }
}
