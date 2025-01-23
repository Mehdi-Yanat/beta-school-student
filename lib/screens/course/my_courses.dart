import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:online_course/screens/course/view_chapters.dart';
import 'package:online_course/theme/color.dart';
import 'package:online_course/utils/helper.dart';
import 'package:provider/provider.dart';

import '../../models/mycourses.dart';
import '../../widgets/appbar.dart';
import '../../providers/course_provider.dart';
import '../../widgets/gradient_button.dart';
import 'course_detail.dart';

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

  // Search State
  TextEditingController _searchController = TextEditingController();
  List<MyCourse> _filteredCourses = [];
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations =
        AppLocalizations.of(context); // Localizations instance
    final courseProvider =
        Provider.of<CourseProvider>(context); // Access CourseProvider
    final courses = courseProvider.myCourses;
    // Filter courses based on search query
    _filteredCourses = _searchQuery.isEmpty
        ? courses
        : courses.where((course) {
            return course.course.title.toLowerCase().contains(_searchQuery);
          }).toList();

    return RefreshIndicator(
      onRefresh: _refreshCourses,
      child: Scaffold(
          backgroundColor: AppColor.appBgColor,
          appBar: CustomAppBar(title: localizations!.my_courses_title),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: localizations.search_hint, // Localization key
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          style: BorderStyle.solid, color: AppColor.brandMain),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12), // Optional
                      borderSide: BorderSide(
                        color: AppColor.brandMain, // Color when not focused
                        width: 2.0, // Border width
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12), // Optional
                      borderSide: BorderSide(
                        color: AppColor.primary, // Color when focused
                        width: 2.0, // Border width when focused
                      ),
                    ),
                    filled: true,
                    fillColor: AppColor.cardColor,
                  ),
                ),
              ),
              // For now, simply display all courses (Disable tabs)
              Expanded(
                child: courseProvider.isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: AppColor.primary,
                        ),
                      )
                    : courses.isEmpty
                        ? Center(
                            child: Text(
                              localizations.no_courses_message,
                              // Add a localization for "No courses available"
                              style: TextStyle(color: AppColor.mainColor),
                            ),
                          )
                        : buildCourseList(localizations, _filteredCourses),
              ),
            ],
          )),
    );
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
                  builder: (context) =>
                      CourseDetailScreen(courseId: course.course.id)),
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
                          Icon(
                            Icons.video_collection_rounded,
                            size: 15,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            '${course.course.chapters.length}',
                            style: TextStyle(
                              color: AppColor.darker,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Icon(
                            Icons.timelapse_rounded,
                            size: 15,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(Helpers.formatHoursAndMinutes(
                              context, course.course.totalWatchTime))
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
                GradientButton(
                  text: AppLocalizations.of(context)!.watch,
                  // Add your localization key or hardcoded text
                  variant: 'blueGradient',
                  // Variant setting (e.g., primary style)
                  color: Colors.white,
                  // Text or icon color
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute<dynamic>(
                          maintainState: true,
                          builder: (context) => ViewChapterScreen(
                              chapterId: course.course.chapters[0].id,
                              courseId: course.course.id,
                              chapter: course.course.chapters[0]),
                        ));
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
