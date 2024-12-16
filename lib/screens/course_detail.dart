import 'package:flutter/material.dart';
import 'package:online_course/theme/color.dart';
import '../utils/data.dart';

class CourseDetailScreen extends StatelessWidget {
  final String courseId;

  const CourseDetailScreen({Key? key, required this.courseId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBgColor,
      appBar: AppBar(
        leading: Icon(Icons.arrow_back, color: Colors.white),
        backgroundColor: AppColor.appBgColor,
        elevation: 0,
        title: Text(
          'Detail',
          style: TextStyle(color: AppColor.labelColor),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: AppColor.appBgColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Course Image
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: NetworkImage(features[0]['image']),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 16),

            // Course Title, Info, and Rating
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'UI/UX Design',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColor.textColor,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.video_library,
                          size: 16, color: AppColor.labelColor),
                      SizedBox(width: 4),
                      Text('6 lessons',
                          style: TextStyle(color: AppColor.labelColor)),
                      SizedBox(width: 16),
                      Icon(Icons.access_time,
                          size: 16, color: AppColor.labelColor),
                      SizedBox(width: 4),
                      Text('10 hours',
                          style: TextStyle(color: AppColor.labelColor)),
                      SizedBox(width: 16),
                      Icon(Icons.star, size: 16, color: AppColor.yellow),
                      SizedBox(width: 4),
                      Text('4.5', style: TextStyle(color: AppColor.labelColor)),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    'About Course',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColor.textColor,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'In publishing and graphic design, Lorem ipsum is a placeholder text commonly used...',
                    style: TextStyle(
                      color: AppColor.labelColor,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Show more',
                    style: TextStyle(
                      color: AppColor.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),

            // Lessons Tab
            DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  TabBar(
                    labelColor: AppColor.primary,
                    indicatorColor: AppColor.primary,
                    unselectedLabelColor: Colors.white,
                    tabs: [
                      Tab(text: 'Lessons'),
                      Tab(text: 'Exercises'),
                    ],
                  ),
                  Container(
                    height: 150,
                    child: TabBarView(
                      children: [
                        ListView(
                          children: [
                            CourseLessonItem(
                              title: 'Introduction to UI/UX Design',
                              duration: '45 minutes',
                              imagePath: features[0]['image'],
                            ),
                            CourseLessonItem(
                              title: 'UI/UX Research',
                              duration: '55 minutes',
                              imagePath: features[0]['image'],
                            ),
                          ],
                        ),
                        Center(
                          child: Text(
                            'Exercises Content Goes Here',
                            style: TextStyle(color: AppColor.textColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),

            // Price and Buy Now Button
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColor.cardColor,
                boxShadow: [
                  BoxShadow(
                    color: AppColor.shadowColor.withOpacity(0.1),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Price',
                        style: TextStyle(color: AppColor.mainColor),
                      ),
                      Text(
                        'DZD 110.00',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColor.darker,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primary,
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    ),
                    child: Text(
                      'Buy Now',
                      style: TextStyle(color: AppColor.glassTextColor),
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

class CourseLessonItem extends StatelessWidget {
  final String title;
  final String duration;
  final String imagePath;

  const CourseLessonItem({
    super.key,
    required this.title,
    required this.duration,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image: NetworkImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: AppColor.textColor,
        ),
      ),
      subtitle: Text(duration, style: TextStyle(color: AppColor.labelColor)),
      trailing:
          Icon(Icons.arrow_forward_ios, size: 16, color: AppColor.labelColor),
    );
  }
}
