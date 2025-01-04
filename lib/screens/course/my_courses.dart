import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:online_course/screens/course/view_chapters.dart';
import 'package:online_course/theme/color.dart';
import 'package:provider/provider.dart';

import '../../models/mycourses.dart';
import '../../widgets/appbar.dart';
import '../../providers/course_provider.dart';

class MyCourseScreen extends StatefulWidget {
  @override
  _MyCourseScreenState createState() => _MyCourseScreenState();
}

class _MyCourseScreenState extends State<MyCourseScreen> {
  Future<void> _refreshCourses() async {
    final courseProvider = Provider.of<CourseProvider>(context, listen: false);
    await courseProvider.fetchMyCourses(
        context); // Ensure this method is implemented in your provider
  }

  @override
  Widget build(BuildContext context) {
    final localizations =
        AppLocalizations.of(context); // Localizations instance
    final courseProvider =
        Provider.of<CourseProvider>(context); // Access CourseProvider

    return Scaffold(
        backgroundColor: AppColor.appBgColor,
        appBar: CustomAppBar(title: localizations!.my_courses_title),
        body: RefreshIndicator(
          onRefresh: _refreshCourses,
          child: Column(
            children: [
              // For now, simply display all courses (Disable tabs)
              Expanded(
                child: courseProvider.isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: AppColor.primary,
                        ),
                      )
                    : courseProvider.myCourses.isEmpty
                        ? Center(
                            child: Text(
                              localizations.no_courses_message,
                              // Add a localization for "No courses available"
                              style: TextStyle(color: AppColor.mainColor),
                            ),
                          )
                        : buildCourseList(
                            localizations, courseProvider.myCourses),
              ),
            ],
          ),
        ));
  }

  // Render the list of courses
  Widget buildCourseList(
      AppLocalizations localizations, List<MyCourse> courses) {
    return ListView.builder(
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];
        // double progress = course.completedLessons / course.totalLessons;

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ViewChapterScreen(
                  chapterId: course.course.chapters[0].id,
                  courseId: course.course.id,
                  chapter: course.course.chapters[0],
                ),
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
                  color: AppColor.shadowColor.withAlpha(25),
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
                  child: course.course.icon?.url != null &&
                          course.course.icon!.url.startsWith('http')
                      ? Image.network(
                          course.course.icon!.url,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            // Fallback if the network image fails to load
                            return Image.asset(
                              "assets/images/course_icon.png",
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            );
                          },
                        )
                      : Image.asset(
                          "assets/images/course_icon.png",
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
                        course.course.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColor.mainColor,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          /*
                          Text(
                            '${course.course.chapters.length} ${localizations.lessons_completed}',
                            style: TextStyle(
                              color: AppColor.textColor,
                              fontSize: 12,
                            ),
                          ),
                          const Spacer(),
                          */

                          Text(
                            '${course.course.chapters.length} ${localizations.total_lessons}',
                            style: TextStyle(
                              color: AppColor.inActiveColor,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      // Progress Bar
                      /*
                      LinearProgressIndicator(
                        value: progress,
                        backgroundColor: AppColor.appBgColor,
                        color: AppColor.primary,
                        minHeight: 5,
                      ),
                      */
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
