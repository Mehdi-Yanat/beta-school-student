import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import localization
import 'package:online_course/providers/auth_provider.dart';
import 'package:online_course/providers/course_provider.dart';
import 'package:online_course/providers/teacher_provider.dart';
import 'package:online_course/screens/course/course_detail.dart';
import 'package:online_course/screens/teacher/teacher_view.dart';
import 'package:online_course/theme/color.dart';
import 'package:online_course/utils/data.dart';
import 'package:online_course/utils/helper.dart';
import 'package:online_course/widgets/category_box.dart';
import 'package:online_course/widgets/feature_item.dart';
import 'package:online_course/widgets/notification_box.dart';
import 'package:online_course/widgets/teacher_item.dart';
import 'package:provider/provider.dart';

import '../widgets/custom_image.dart';
import '../widgets/sliver_app_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedCategory = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshData();
    });
  }

  Future<void> _refreshData() async {
    // Refresh all data concurrently
    await Future.wait([
      context.read<CourseProvider>().fetchCourses(
            refresh: true,
            filters: {
              'subject': _selectedCategory.isEmpty ? null : _selectedCategory
            },
            context: context,
          ),
      context.read<TeacherProvider>().fetchTeachers(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColor.appBgColor,
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: CustomScrollView(
          physics:
              AlwaysScrollableScrollPhysics(), // Important for RefreshIndicator
          slivers: [
            CustomSliverAppBar(
              pinned: true,
              snap: true,
              floating: true,
              toolbarHeight: 100,
              title: _buildAppBar(localizations),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildBody(localizations),
                childCount: 1,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(localizations) {
    return Consumer<AuthProvider>(builder: (context, authProvider, widget) {
      final isArabic = Localizations.localeOf(context).languageCode == 'ar';

      String getFormattedName() {
        if (authProvider.student == null) return '';

        final firstName = isArabic
            ? (authProvider.student!.firstNameAr ??
                authProvider.student!.firstName ??
                '')
            : (authProvider.student!.firstName ?? '');

        final lastName = isArabic
            ? (authProvider.student!.lastNameAr ??
                authProvider.student!.lastName ??
                '')
            : (authProvider.student!.lastName ?? '');

        return '$firstName $lastName'.trim();
      }

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(
                20.0, 0, 0, 0), // Adjust margin values as needed
            child: CustomImage(
              authProvider.student?.profilePic ?? "",
              width: 55,
              height: 55,
              radius: 17,
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizations.greeting,
                  style: TextStyle(
                      color: AppColor.labelColor,
                      fontSize: 14,
                      fontFamily: 'Rubik'),
                ),
                const SizedBox(height: 5),
                Text(
                  getFormattedName(),
                  style: TextStyle(
                      color: AppColor.labelColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 22,
                      fontFamily: 'Rubik'),
                ),
              ],
            ),
          ),
          NotificationBox(
            notifiedNumber: 1,
            size: 10,
          ),
        ],
      );
    });
  }

  Widget _buildBody(localizations) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCategories(localizations),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
            child: Text(
              localizations.featured, // Localized "Featured" title
              style: TextStyle(
                color: AppColor.mainColor,
                fontWeight: FontWeight.w800,
                fontSize: 30,
              ),
            ),
          ),
          _buildCoursesAccepted(),
          const SizedBox(height: 1),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  localizations.teachers,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: AppColor.mainColor,
                  ),
                ),
              ],
            ),
          ),
          _buildAcceptedTeachers(),
        ],
      ),
    );
  }

  Widget _buildCategories(AppLocalizations localizations) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(15, 10, 0, 10),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((category) {
          final isSelected = _selectedCategory == category['id'];
          return Padding(
            padding: const EdgeInsets.only(right: 15),
            child: CategoryBox(
              data: category,
              isSelected: isSelected,
              selectedColor: AppColor.mainColor,
              onTap: () {
                setState(() => _selectedCategory = category['id']);
                // Filter courses based on selected category
                context.read<CourseProvider>().setFilters(
                    subject: category['id'] == '' ? null : category['id'],
                    refresh: true,
                    context: context);
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCoursesAccepted() {
    return Consumer<CourseProvider>(
      builder: (context, courseProvider, child) {
        if (courseProvider.isLoading) {
          return Center(
            child: Column(
              mainAxisSize:
                  MainAxisSize.min, // Keeps the column as compact as possible
              children: [
                CircularProgressIndicator(),
                SizedBox(
                    height:
                        50), // Adds spacing of 50 below the progress indicator
              ],
            ),
          );
        }

        if (courseProvider.courses.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/empty-folder.png",
                  width: 200,
                ),
              ],
            ),
          );
        }

        return CarouselSlider(
          options: CarouselOptions(
            height: 400,
            enableInfiniteScroll: false,
            animateToClosest: true,
            enlargeCenterPage: true,
            disableCenter: true,
            viewportFraction: .75,
          ),
          items: courseProvider.courses.map((course) {
            final isArabic =
                Localizations.localeOf(context).languageCode == 'ar';
            final fullName = isArabic
                ? "${course.teacher.user.firstNameAr ?? course.teacher.user.firstName} ${course.teacher.user.lastNameAr ?? course.teacher.user.lastName}"
                : "${course.teacher.user.firstName} ${course.teacher.user.lastName}";
            final firstChapter =
                course.chapters.isNotEmpty ? course.chapters.first : null;
            final totalDuration = course.chapters
                .fold<int>(0, (sum, chapter) => sum + (chapter.duration));

            final formatedDuration = Helpers.formatTime(totalDuration);

            final finalPrice = course.discount != null
                ? course.price - course.discount!
                : course.price;

            return FeatureItem(
              data: {
                "thumbnail": firstChapter?.thumbnail?.url ??
                    "assets/images/course_icon.png",
                "icon": course.icon?.url ?? "assets/images/course_icon.png",
                "name": course.title,
                "price": "${finalPrice.toString()} DA",
                "session":
                    "${course.chapters.length} ${AppLocalizations.of(context)!.courses}",
                "duration":
                    "$formatedDuration ${AppLocalizations.of(context)!.hours}",
                "teacherName": "${fullName}",
                "teacherProfilePic": course.teacher.user.profilePic?.url,
                "enrollments": course.currentEnrollment.toString()
              },
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CourseDetailScreen(courseId: course.id),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildAcceptedTeachers() {
    return Consumer<TeacherProvider>(
      builder: (context, teacherProvider, child) {
        if (teacherProvider.isLoading) {
          return Center(
            child: Column(
              mainAxisSize:
                  MainAxisSize.min, // Keeps the column as compact as possible
              children: [
                SizedBox(height: 50),
                CircularProgressIndicator(),
                SizedBox(
                    height:
                        50), // Adds spacing of 50 below the progress indicator
              ],
            ),
          );
        }
        if (teacherProvider.teachers.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person_off, size: 64, color: AppColor.mainColor),
                const SizedBox(height: 50),
                Text(
                  AppLocalizations.of(context)!.no_teachers_found,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColor.mainColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(15, 15, 0, 15),
          scrollDirection: Axis.horizontal,
          child: Row(
            children: teacherProvider.teachers.map((teacher) {
              final isArabic =
                  Localizations.localeOf(context).languageCode == 'ar';
              final fullName = isArabic
                  ? "${teacher.firstNameAr ?? teacher.firstName} ${teacher.lastNameAr ?? teacher.lastName}"
                  : "${teacher.firstName} ${teacher.lastName}";

              final profilePic = teacher.profilePic?.url != null
                  ? teacher.profilePic?.url
                  : "assets/images/profile.png";

              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: TeacherItem(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TeacherView(teacherId: teacher.id),
                    ),
                  ),
                  data: {
                    "image": profilePic,
                    "name": fullName,
                    "subject": teacher.teacherInfo.subject,
                    "institution": teacher.teacherInfo.institution,
                    "experience":
                        "${teacher.teacherInfo.yearsOfExperience} years",
                    "review": "4.5",
                  },
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
