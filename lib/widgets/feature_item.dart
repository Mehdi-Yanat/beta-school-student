import 'package:flutter/material.dart';
import 'package:online_course/theme/color.dart';
import 'package:online_course/widgets/course_image.dart';

import 'custom_image.dart';

class FeatureItem extends StatelessWidget {
  FeatureItem({
    Key? key,
    required this.data,
    this.width = 300,
    this.height = 300,
    this.onTap,
  }) : super(key: key);

  final data;
  final double width;
  final double height;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColor.shadowColor.withValues(alpha: 0.1),
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(1, 1), // changes position of shadow
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background thumbnail with blur
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Stack(
                children: [
                  CourseImage(
                    thumbnailUrl: data["thumbnail"],
                    iconUrl: data["icon"],
                    width: width,
                    height: 190,
                  ),
                  // Gradient overlay
                  Container(
                    width: double.infinity,
                    height: 190,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.1),
                          Colors.black.withValues(alpha: 0.5),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Centered course icon
            Positioned(
              top: 60,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(35),
                    child: CustomImage(
                      data["icon"] ?? "assets/images/course_icon.png",
                      fit: BoxFit.cover,
                      isNetwork: data["icon"].toString().startsWith('https')
                          ? true
                          : false,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 170,
              right: 15,
              child: _buildPrice(),
            ),
            Positioned(
              top: 210,
              child: _buildInfo(),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInfo() {
    return Container(
      width: width - 20,
      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data["name"],
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 17,
              color: AppColor.mainColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          _buildAttributes(),
        ],
      ),
    );
  }

  Widget _buildPrice() {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColor.primary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColor.shadowColor.withValues(alpha: 0.05),
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Text(
        data["price"],
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildAttributes() {
    return Container(
      width: width - 20,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: _getAttribute(
              Icons.play_circle_outlined,
              AppColor.darker,
              data["session"] ?? "0 Sessions",
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: _getAttribute(
              Icons.schedule_rounded,
              AppColor.darker,
              data["duration"] ?? "0 min",
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: _getAttribute(
              Icons.person_outline,
              AppColor.darker,
              data["teacherName"] ?? "Unknown",
            ),
          ),
        ],
      ),
    );
  }

  Widget _getAttribute(IconData icon, Color color, String info) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: color,
        ),
        const SizedBox(width: 3),
        Expanded(
          child: Text(
            info,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColor.darker,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}
