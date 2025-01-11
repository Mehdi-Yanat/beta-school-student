import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import localization
import 'package:online_course/providers/auth_provider.dart';
import 'package:online_course/providers/course_provider.dart';
import 'package:online_course/providers/teacher_provider.dart';
import 'package:online_course/screens/course/course_detail.dart';
import 'package:online_course/screens/teacher/teacher_view.dart';
import 'package:online_course/services/auth_service.dart';
import 'package:online_course/theme/color.dart';
import 'package:online_course/utils/data.dart';
import 'package:online_course/utils/helper.dart';
import 'package:online_course/widgets/category_box.dart';
import 'package:online_course/widgets/feature_item.dart';
import 'package:online_course/widgets/teacher_item.dart';
import 'package:provider/provider.dart';

import '../utils/translation.dart';
import '../widgets/custom_image.dart';
import '../widgets/sliver_app_bar.dart';
import '../widgets/snackbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedCategory = '';
  int? remainingCooldownTime;
  Timer? cooldownTimer;
  bool isOnCooldown = false;

  void startCooldown(int duration) {
    setState(() {
      remainingCooldownTime = duration;
      isOnCooldown = true;
    });

    // Start the timer
    cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingCooldownTime == null || remainingCooldownTime! <= 0) {
        timer.cancel(); // Stop the timer when cooldown ends
        setState(() {
          isOnCooldown = false;
          remainingCooldownTime = null;
        });
      } else {
        setState(() {
          remainingCooldownTime = remainingCooldownTime! - 1; // Decrease time
        });
      }
    });
  }

  Future<void> _handleVerificationButtonPressed() async {
    final success = await AuthService.sendEmailVerification();

    // Use the reusable snackbar to display the result
    if (success) {
      SnackBarHelper.showSuccessSnackBar(
        context,
        AppLocalizations.of(context)!.verification_email_sent_success,
      );
      startCooldown(30); // Start cooldown only if the request is successful
    } else {
      SnackBarHelper.showErrorSnackBar(
        context,
        AppLocalizations.of(context)!.verification_email_sent_failure,
      );
    }
  }

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
      context.read<AuthProvider>().refreshProfile(),
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
                authProvider.student!.firstName)
            : (authProvider.student!.firstName);

        final lastName = isArabic
            ? (authProvider.student!.lastNameAr ??
                authProvider.student!.lastName)
            : (authProvider.student!.lastName);

        return '$firstName $lastName'.trim();
      }

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsetsDirectional.only(end: 20),
            child: CustomImage(
              authProvider.student?.profilePic ?? "",
              width: 55,
              height: 55,
              radius: 17,
            ),
          ),
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizations.greeting + ' 👋',
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
                const SizedBox(height: 5),
                Row(
                  children: [
                    Flexible(
                        child: Text(
                      TranslationHelper.getTranslatedClass(
                          context, authProvider.student?.studentClass),
                      style:
                          TextStyle(color: AppColor.labelColor, fontSize: 15),
                    ))
                  ],
                ),
              ],
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              "assets/icons/app_icon.png",
              opacity: AlwaysStoppedAnimation(0.91),
            ),
          )
          // NotificationBox(
          //   notifiedNumber: 0,
          //   size: 10,
          // ),
        ],
      );
    });
  }

  Widget _buildBody(localizations) {
    return Consumer<AuthProvider>(builder: (context, authProvider, _) {
      final student = authProvider.student;

      // Check if the student's status is ACCEPTED
      if (student != null && student.status == 'ACCEPTED') {
        // Render the original body
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5),
              Padding(
                  padding: EdgeInsetsDirectional.only(start: 25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        textAlign: TextAlign.start,
                        '✨ ' + localizations.featured,
                        // Localized "Featured" title with shining emoji
                        style: TextStyle(
                          color: AppColor.mainColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 23,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.only(start: 35),
                        child: Text(
                          textAlign: TextAlign.start,
                          localizations.recommended_courses_description,
                          style: TextStyle(
                            color: AppColor.textColor,
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                        ),
                      )
                    ],
                  )),
              const SizedBox(
                height: 15,
              ),
              _buildCategories(localizations),
              const SizedBox(height: 15),
              _buildCoursesAccepted(),
              const SizedBox(height: 35),
              Padding(
                padding: EdgeInsetsDirectional.only(start: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '🎓 ' + localizations.teachers,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: AppColor.mainColor,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.only(start: 35),
                      child: Text(
                        textAlign: TextAlign.start,
                        localizations.recommended_teachers_description,
                        style: TextStyle(
                          color: AppColor.textColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              _buildAcceptedTeachers(),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        );
      } else if (!student?.isEmailVerified) {
        // Render the validation message
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/no-email.png",
                  width: 200,
                ),
                const SizedBox(height: 20),
                Text(
                  AppLocalizations.of(context)!.email_not_verified_message,
                  // Your localized message here
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColor.mainColor,
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    // Resend email logic
                    if (!isOnCooldown) {
                      _handleVerificationButtonPressed();
                    }
                  },
                  child: Text(
                    isOnCooldown
                        ? "${AppLocalizations.of(context)!.wait} ${remainingCooldownTime}s" // Cooldown button text
                        : AppLocalizations.of(context)!
                            .send_verification_button,
                    // Button text from localization
                    style: const TextStyle(
                        fontSize: 16, color: AppColor.labelColor),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary,
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                Image.asset(
                  "assets/images/wait-verification.png",
                  width: 200,
                ),
                const SizedBox(height: 20),
                Text(
                  AppLocalizations.of(context)!.please_wait_verification,
                  // Your localized message here
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColor.mainColor,
                  ),
                ),
              ],
            ),
          ),
        );
      }
    });
  }

  // Widget _buildBody(localizations) {
  //   return SingleChildScrollView(
  //     padding: const EdgeInsets.symmetric(vertical: 10),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         _buildCategories(localizations),
  //         const SizedBox(
  //           height: 15,
  //         ),
  //         Padding(
  //           padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
  //           child: Text(
  //             localizations.featured, // Localized "Featured" title
  //             style: TextStyle(
  //               color: AppColor.mainColor,
  //               fontWeight: FontWeight.w800,
  //               fontSize: 30,
  //             ),
  //           ),
  //         ),
  //         _buildCoursesAccepted(),
  //         const SizedBox(height: 1),
  //         Padding(
  //           padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Text(
  //                 localizations.teachers,
  //                 style: TextStyle(
  //                   fontSize: 22,
  //                   fontWeight: FontWeight.w600,
  //                   color: AppColor.mainColor,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //         _buildAcceptedTeachers(),
  //       ],
  //     ),
  //   );
  // }

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
                SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context)!.no_courses_found,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColor.mainColor,
                  ),
                ),
              ],
            ),
          );
        }

        return CarouselSlider(
          options: CarouselOptions(
            height: 380,
            enableInfiniteScroll: false,
            animateToClosest: true,
            enlargeCenterPage: true,
            disableCenter: true,
            viewportFraction: .75,
            pageSnapping: true,
          ),
          items: courseProvider.courses.map((course) {
            final isArabic =
                Localizations.localeOf(context).languageCode == 'ar';
            final fullName = isArabic
                ? "${course.teacher.user.firstNameAr ?? course.teacher.user.firstName} ${course.teacher.user.lastNameAr ?? course.teacher.user.lastName}"
                : "${course.teacher.user.firstName} ${course.teacher.user.lastName}";
            final firstChapter =
                course.chapters.isNotEmpty ? course.chapters.first : null;
            final totalDuration = course.totalWatchTime;

            final formatedDurationMinutes =
                Helpers.formatHoursAndMinutes(context, totalDuration!);

            // Calculate discount percentage and prices
            final hasDiscount = course.discount != null && course.discount! > 0;
            final originalPrice = course.price;
            final discountAmount =
                hasDiscount ? (course.price * course.discount! / 100) : 0;
            final finalPrice =
                hasDiscount ? (course.price - discountAmount).toInt() : course.price.toInt();

            return FeatureItem(
              data: {
                "thumbnail": firstChapter?.thumbnail?.url ??
                    "assets/images/course_icon.png",
                "icon": course.icon?.url ?? "assets/images/course_icon.png",
                "name": course.title,
                "originalPrice":
                    hasDiscount ? "${originalPrice.toString()} " + AppLocalizations.of(context)!.dzd  : "",
                "price": "${finalPrice.toString()} " + AppLocalizations.of(context)!.dzd,
                "discountPercentage": course.discount.toString(),
                "session":
                    "${course.chapters.length} ${AppLocalizations.of(context)!.courses}",
                "duration": "${formatedDurationMinutes}",
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
                Image.asset(
                  "assets/images/empty-box.png",
                  width: 200,
                ),
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
                    "totalEnrolledStudents":
                        teacher.teacherInfo.totalEnrolledStudents,
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
