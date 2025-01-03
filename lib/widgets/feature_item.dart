import 'package:flutter/material.dart';
import 'package:online_course/theme/color.dart';
import 'package:online_course/widgets/course_image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import localization

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
              Color(0xFF00BBFF), // main
              Color(0xFF21D4FD), // state
            ],
            begin: Alignment(0.838, 0.546), // Start point shifted for 127 degrees
            end: Alignment(-0.838, -0.546), // End point aligned for 127 degrees
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColor.shadowColor.withValues(alpha: 0.2),
              spreadRadius: 3,
              blurRadius: 10,
              offset: Offset(1, 3), // changes position of shadow
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
                      isNetwork: data["icon"].toString().startsWith('https')
                          ? true
                          : false,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 150,
              right: 0,
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF21D4FD), // main
                        Color(0xFF00BBFF), // state
                      ],
                      begin: Alignment(-0.13743, 0.99051), // Start point for 97.89 degrees
                      end: Alignment(0.13743, -0.99051),   // End point for 97.89 degrees
                    ),
                    borderRadius: BorderRadius.circular(8),
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
                    AppLocalizations.of(context)!.courses,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 18,
                        color: AppColor.labelColor,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Rubik'
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
        const SizedBox(
          height: 10,
        ),
          _buildTeacherDetails(),
          const SizedBox(
            height: 10,
          ),
          Text(
            data["name"],
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 20,
              color: AppColor.labelColor,
              fontWeight: FontWeight.bold,
              fontFamily: 'Rubik'
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
              Icons.play_circle_fill,
              AppColor.labelColor,
              data["session"] ?? "0 Sessions",
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: _getAttribute(
              Icons.timelapse_rounded,
              AppColor.labelColor,
              data["duration"] ?? "0 min",
            ),
          ),
          const SizedBox(width: 8),
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
        const SizedBox(width: 3),
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
        CustomImage(
          data["teacherProfilePic"] ?? "assets/images/profile.png",
          fit: BoxFit.cover,
          width: 50,
          height: 50,
          isNetwork: data["teacherProfilePic"].toString().startsWith('https')
              ? true
              : false,
        ),
        Container(
          margin: EdgeInsets.all(10),
            child: Text(data["teacherName"],
              style: TextStyle(
                  color: AppColor.labelColor,
                fontWeight: FontWeight.normal,
                fontSize: 19
              ),
            ))

      ],
    );

 }
}
