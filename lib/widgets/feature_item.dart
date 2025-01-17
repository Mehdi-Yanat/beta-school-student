import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:online_course/theme/color.dart';
import 'package:online_course/widgets/course_image.dart';
// Import localization

import 'custom_image.dart';

class FeatureItem extends StatelessWidget {
  FeatureItem({
    Key? key,
    required this.data,
    this.width = 300,
    this.height = 500,
    this.onTap,
  }) : super(key: key);

  final data;
  final double width;
  final double height;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final bool hasDiscount = data["discountPercentage"] != null &&
        data["originalPrice"] != null &&
        (num.tryParse(data["discountPercentage"].toString()) ?? 0) > 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF00BBFF),
              Color(0xFF21D4FD),
            ],
            begin: Alignment(0.838, 0.546),
            end: Alignment(-0.838, -0.546),
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            // Background and thumbnail
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Stack(
                children: [
                  CourseImage(
                    thumbnailUrl: data["thumbnail"],
                    iconUrl: data["icon"],
                    width: width,
                    height: 190,
                  ),
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

            // Discount badge (if applicable)
            if (hasDiscount)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.red,
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
                      Icon(
                        Icons.local_offer,
                        color: Colors.white,
                        size: 16,
                      ),
                      SizedBox(width: 4),
                      Text(
                        "-${data["discountPercentage"]}%",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Course icon
            Positioned(
              top: 10,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 150,
                  height: 150,
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
                      isNetwork: data["icon"].toString().startsWith('https'),
                    ),
                  ),
                ),
              ),
            ),

            // Price section
            Positioned(
              top: hasDiscount ? 150 : 170,
              right: 15,
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.shadowColor.withValues(alpha: 0.5),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (hasDiscount) ...[
                      Text(
                        data["originalPrice"],
                        style: TextStyle(
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(height: 2),
                    ],
                    Text(
                      data["price"],
                      style: TextStyle(
                        color: hasDiscount ? Colors.red : AppColor.darker,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Course info
            Positioned(
              top: 210,
              child: _buildInfo(),
            ),
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
          SizedBox(height: 10),
          _buildTeacherDetails(),
          SizedBox(height: 2),
          Text(
            data["name"],
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 22,
              color: AppColor.labelColor,
              fontWeight: FontWeight.bold,
              fontFamily: 'Rubik',
            ),
          ),
          SizedBox(height: 10),
          _buildAttributes(),
        ],
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
              Icons.play_circle_fill,
              AppColor.labelColor,
              data["session"] ?? "0 Sessions",
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: _getAttribute(
              Icons.timelapse_rounded,
              AppColor.labelColor,
              data["duration"] ?? "0 min",
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: _getAttribute(
              Icons.people_alt_rounded,
              AppColor.labelColor,
              data["enrollments"] ?? "Unknown",
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
          size: 22,
          color: color,
        ),
        SizedBox(width: 3),
        Expanded(
          child: Text(
            info,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColor.labelColor,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTeacherDetails() {
    return Row(
      children: [
        data["teacherProfilePic"] != null
            ? CustomImage(
                data["teacherProfilePic"],
                fit: BoxFit.cover,
                width: 40,
                height: 40,
                isNetwork:
                    data["teacherProfilePic"].toString().startsWith('https'),
              )
            : SvgPicture.asset(
                "assets/icons/profile.svg",
                color: Colors.white,
              ),
        Container(
          margin: EdgeInsets.all(10),
          child: Text(
            data["teacherName"],
            style: TextStyle(
              color: AppColor.labelColor,
              fontWeight: FontWeight.normal,
              fontSize: 19,
            ),
          ),
        )
      ],
    );
  }
}
