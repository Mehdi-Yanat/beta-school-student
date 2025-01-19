import 'package:flutter/material.dart';
import 'package:online_course/theme/color.dart';
import 'package:online_course/utils/translation.dart';

class CourseCard extends StatelessWidget {
  final Map<String, dynamic> course;
  final VoidCallback? onTap;

  const CourseCard({
    Key? key,
    required this.course,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 300, // Adjust the height according to your layout
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 5,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Course Thumbnail
            Container(
              height: 120,
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                child: Stack(
                  children: [
                    // Course Image
                    Container(
                      height: 120,
                      width: double.infinity,
                      child: course['icon'] != null
                          ? Image.network(
                              course['icon']['url'],
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                color: AppColor.textBoxColor,
                                child: Icon(Icons.image_not_supported),
                              ),
                            )
                          : Container(
                              color: AppColor.textBoxColor,
                              child: Icon(Icons.image_not_supported),
                            ),
                    ),
                    // Level Badge
                    if (course['rating'] ?? 0 * 5 > 2.7)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColor.mainColor.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(children: [
                            Icon(
                              Icons.star_rounded,
                              color: AppColor.yellow,
                              size: 20,
                            ),
                            Text(
                              course['rating'] ?? "0",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            )
                          ]),
                        ),
                      ),
                    // Course Class Label - Position Absolute (Bottom Left of the Image)
                    if (course['class'] != null &&
                        (course['class'] as List).isNotEmpty)
                      Positioned(
                        bottom: 8, // Position near the bottom of the image
                        left: 8, // Offset from the left edge
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4), // Label Padding
                          decoration: BoxDecoration(
                            color: Colors.black
                                .withValues(alpha: 0.6), // Background
                            borderRadius:
                                BorderRadius.circular(8), // Rounded edges
                          ),
                          child: Text(
                            TranslationHelper.getTranslatedClass(
                              context,
                              (course['class'] as List).first.toString(),
                            ),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // Course Info
            Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course['title'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColor.darker,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    course['description'],
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 10,
                      color: AppColor.textColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${course['price']} DZD',
                    style: TextStyle(
                      color: AppColor.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
