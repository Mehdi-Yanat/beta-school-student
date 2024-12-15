import 'package:flutter/material.dart';
import '../theme/color.dart';
import 'package:online_course/theme/color.dart';

class MyCourseScreen extends StatefulWidget {
  @override
  _MyCourseScreenState createState() => _MyCourseScreenState();
}

class _MyCourseScreenState extends State<MyCourseScreen> {
  int selectedTabIndex = 0;

  // Dummy course data
  final List<Map<String, dynamic>> coursesInProgress = [
    {
      'title': 'UI/UX Design',
      'image':
          'https://images.unsplash.com/photo-1596548438137-d51ea5c83ca5?ixlib=rb-1.2.1&auto=format&fit=crop&w=100&q=60', // Replace with real URL
      'completedLessons': 2,
      'totalLessons': 4,
    },
    {
      'title': 'Painting',
      'image':
          'https://images.unsplash.com/photo-1596548438137-d51ea5c83ca5?ixlib=rb-1.2.1&auto=format&fit=crop&w=100&q=60', // Replace with real URL
      'completedLessons': 7,
      'totalLessons': 10,
    },
    {
      'title': 'Mobile App Development',
      'image':
          'https://images.unsplash.com/photo-1596548438137-d51ea5c83ca5?ixlib=rb-1.2.1&auto=format&fit=crop&w=100&q=60', // Replace with real URL
      'completedLessons': 8,
      'totalLessons': 10,
    },
    {
      'title': 'Photography',
      'image':
          'https://images.unsplash.com/photo-1596548438137-d51ea5c83ca5?ixlib=rb-1.2.1&auto=format&fit=crop&w=100&q=60', // Replace with real URL
      'completedLessons': 3,
      'totalLessons': 5,
    },
  ];

  final List<Map<String, dynamic>> completedCourses = [
    {
      'title': 'Graphic Design',
      'image':
          'https://images.unsplash.com/photo-1596548438137-d51ea5c83ca5?ixlib=rb-1.2.1&auto=format&fit=crop&w=100&q=60',
      'completedLessons': 8,
      'totalLessons': 8,
    },
    {
      'title': 'Cooking Essentials',
      'image':
          'https://images.unsplash.com/photo-1596548438137-d51ea5c83ca5?ixlib=rb-1.2.1&auto=format&fit=crop&w=100&q=60',
      'completedLessons': 5,
      'totalLessons': 5,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBgColor,
      appBar: AppBar(
        backgroundColor: AppColor.appBarColor,
        elevation: 0,
        title: Text(
          'My Course',
          style: TextStyle(
            color: AppColor.mainColor,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Tab Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedTabIndex = 0;
                    });
                  },
                  child: Column(
                    children: [
                      Text(
                        'Progress (4)',
                        style: TextStyle(
                          color: selectedTabIndex == 0
                              ? AppColor.primary
                              : AppColor.labelColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      if (selectedTabIndex == 0)
                        Container(
                          height: 2,
                          color: AppColor.primary,
                          width: 60,
                        ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedTabIndex = 1;
                    });
                  },
                  child: Column(
                    children: [
                      Text(
                        'Completed (8)',
                        style: TextStyle(
                          color: selectedTabIndex == 1
                              ? AppColor.primary
                              : AppColor.labelColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      if (selectedTabIndex == 1)
                        Container(
                          height: 2,
                          color: AppColor.primary,
                          width: 60,
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),

          // Course List
          Expanded(
            child: selectedTabIndex == 0
                ? buildCourseList(coursesInProgress)
                : buildCourseList(completedCourses),
          ),
        ],
      ),
    );
  }

  Widget buildCourseList(List<Map<String, dynamic>> courses) {
    return ListView.builder(
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];
        double progress = course['completedLessons'] / course['totalLessons'];

        return Container(
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColor.cardColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColor.shadowColor.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Course Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  course['image'],
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 12),

              // Course Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course['title'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColor.textColor,
                      ),
                    ),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          '${course['completedLessons']} lessons',
                          style:
                              TextStyle(color: AppColor.primary, fontSize: 12),
                        ),
                        Spacer(),
                        Text(
                          '${course['totalLessons']} lessons',
                          style: TextStyle(
                              color: AppColor.inActiveColor, fontSize: 12),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    // Progress Bar
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: AppColor.appBgColor,
                      color: AppColor.blue,
                      minHeight: 5,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
