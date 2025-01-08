import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:online_course/theme/color.dart';

class BottomBarItem extends StatelessWidget {
  const BottomBarItem(
    this.icon, {
    this.onTap,
    this.color = Colors.grey,
    this.activeColor = AppColor.primary,
    this.isActive = false,
    this.isNotified = false,
    this.isMiddle = false,
  });

  final String icon;
  final Color color;
  final Color activeColor;
  final bool isNotified;
  final bool isActive;
  final bool isMiddle;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          margin: isMiddle ? !isActive ? EdgeInsets.fromLTRB(0, 0, 0, 30) : EdgeInsets.zero : EdgeInsets.zero,
          duration: const Duration(milliseconds: 200),
          curve: Curves.fastOutSlowIn,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            boxShadow: isMiddle
                ? [
                    BoxShadow(
                      color: AppColor.primary
                          .withOpacity(0.3), // Shadow color with transparency
                      blurRadius: isActive? 1 : 20, // Blurry edges of the shadow
                      spreadRadius:1, // Spread the shadow slightly
                      offset: Offset(0, isActive ? 1 : 12), // Shadow offset (upward
                    )
                  ]
                : null,
            borderRadius: BorderRadius.circular(12),
            gradient: isMiddle
                ? LinearGradient(
                    colors: [
                      Color(0xFF0075FF), // main
                      Color(0xFF21D4FD), // state
                    ],
                    begin: Alignment(
                        0.838, 0.546), // Start point shifted for 127 degrees
                    end: Alignment(
                        -0.838, -0.546), // End point aligned for 127 degrees
                  )
                : null,
            color: isActive ? AppColor.labelColor : Colors.white,
          ),
          child: SvgPicture.asset(
            icon,
            color: isMiddle ? Colors.white : null,
            width: isMiddle ? 40 : 35,
            height: isMiddle ? 40 : 35,
          ),
        ),
      );
  }
}
