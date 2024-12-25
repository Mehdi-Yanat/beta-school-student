import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import localization
import 'package:online_course/screens/view_chapters.dart';
import 'package:online_course/theme/color.dart';

import '../widgets/appbar.dart';

class MyCourseScreen extends StatefulWidget {
  @override
  _MyCourseScreenState createState() => _MyCourseScreenState();
}

class _MyCourseScreenState extends State<MyCourseScreen> {
  int selectedTabIndex = 0;

  // PageController for managing PageView
  final PageController _pageController = PageController();

  // Dummy course data
  final List<Map<String, dynamic>> coursesInProgress = [
    {
      'title': 'UI/UX Design',
      'image':
          'https://images.unsplash.com/photo-1596548438137-d51ea5c83ca5?ixlib=rb-1.2.1&auto=format&fit=crop&w=100&q=60',
      'completedLessons': 2,
      'totalLessons': 4,
    },
    {
      'title': 'Painting',
      'image':
          'https://images.unsplash.com/photo-1596548438137-d51ea5c83ca5?ixlib=rb-1.2.1&auto=format&fit=crop&w=100&q=60',
      'completedLessons': 7,
      'totalLessons': 10,
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
    final localizations =
        AppLocalizations.of(context); // Localizations instance
    return Scaffold(
      backgroundColor: AppColor.appBgColor,
      appBar: CustomAppBar(
          title: localizations!.my_courses_title), // Localized title
      body: Column(
        children: [
          // Tab Bar
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Progress Tab
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedTabIndex = 0;
                      });
                      // Animate PageView to index 0
                      _pageController.animateToPage(
                        0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Column(
                      children: [
                        Text(
                          '${localizations.progress_tab} (${coursesInProgress.length})',
                          style: TextStyle(
                            color: selectedTabIndex == 0
                                ? AppColor.primary
                                : AppColor.mainColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
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
                // Completed Tab
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedTabIndex = 1;
                      });
                      // Animate PageView to index 1
                      _pageController.animateToPage(
                        1,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Column(
                      children: [
                        Text(
                          '${localizations.completed_tab} (${completedCourses.length})',
                          style: TextStyle(
                            color: selectedTabIndex == 1
                                ? AppColor.primary
                                : AppColor.mainColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
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
          ),
          const SizedBox(height: 12),

          // PageView for swiping between Progress and Completed
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                // Update selectedTabIndex when user swipes
                setState(() {
                  selectedTabIndex = index;
                });
              },
              children: [
                // Progress Courses
                buildCourseList(localizations, coursesInProgress),

                // Completed Courses
                buildCourseList(localizations, completedCourses),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // List of courses (shared for Progress and Completed)
  Widget buildCourseList(
      AppLocalizations localizations, List<Map<String, dynamic>> courses) {
    return ListView.builder(
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];
        double progress = course['completedLessons'] / course['totalLessons'];

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ViewChapterScreen(chapterId: 'chapterId'), // Dummy id
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColor.cardColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColor.shadowColor.withValues(alpha:0.1),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
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
                const SizedBox(width: 12),
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
                          color: AppColor.mainColor,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Text(
                            '${course['completedLessons']} ${localizations.lessons}',
                            style: TextStyle(
                              color: AppColor.textColor,
                              fontSize: 12,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${course['totalLessons']} ${localizations.lessons}',
                            style: TextStyle(
                              color: AppColor.inActiveColor,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      // Progress Bar
                      LinearProgressIndicator(
                        value: progress,
                        backgroundColor: AppColor.appBgColor,
                        color: AppColor.primary,
                        minHeight: 5,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
