import 'package:badges/badges.dart' as badge_lib;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:online_course/theme/color.dart';

class NotificationBox extends StatelessWidget {
  NotificationBox({
    Key? key,
    this.onTap,
    this.size = 5,
    this.notifiedNumber = 0,
  }) : super(key: key);

  final GestureTapCallback? onTap;
  final int notifiedNumber;
  final double size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(size),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          color: Colors.white,
          // border: Border.all(
          //   color: Colors.grey.withValues(alpha: 0.3),
          // ),
        ),
        child: notifiedNumber > 0 ? _buildIconNotified() : _buildIcon(),
      ),
    );
  }

  Widget _buildIconNotified() {
    return badge_lib.Badge(
      badgeContent: Text('5'),
      child: SvgPicture.asset(
        "assets/icons/bell.svg",
        width: 30,
        height: 30,
      ),
    );
  }

  Widget _buildIcon() {
    return SvgPicture.asset(
      "assets/icons/bell.svg",
      width: 30,
      height: 30,
    );
  }
}
