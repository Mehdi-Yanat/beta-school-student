import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import localization
import 'package:online_course/providers/auth_provider.dart';
import 'package:online_course/providers/course_provider.dart';
import 'package:online_course/screens/course/view_chapters.dart';
import 'package:online_course/theme/color.dart';
import 'package:online_course/utils/helper.dart';
import 'package:online_course/utils/translation.dart';
import 'package:online_course/widgets/CardFb1.dart';
import 'package:online_course/widgets/DialogFb3.dart';
import 'package:online_course/widgets/LikeListTile.dart';
import 'package:online_course/widgets/course_image.dart';
import 'package:online_course/widgets/gradient_button.dart';
import 'package:provider/provider.dart';
import '../../widgets/appbar.dart';
import '../teacher/teacher_view.dart';

class CourseDetailScreen extends StatelessWidget {
  final String courseId;

  const CourseDetailScreen({Key? key, required this.courseId})
      : super(key: key);

  Future<void> _refreshCourseData(BuildContext context) async {
    final provider = Provider.of<CourseProvider>(context, listen: false);
    await Future.wait([
      provider.fetchCourse(courseId, context),
      provider.fetchChaptersForCourse(courseId, context),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CourseProvider()
        ..fetchCourse(courseId, context)
        ..fetchChaptersForCourse(courseId, context),
      child: Consumer2<CourseProvider, AuthProvider>(
        builder: (context, provider, authProvider, _) {
          if (provider.isLoading || provider.isLoadingChapter) {
            return Scaffold(
              appBar: CustomAppBar(
                title: AppLocalizations.of(context)!.course_detail_title,
              ),
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (provider.error != null) {
            return Scaffold(
              appBar: CustomAppBar(
                title: AppLocalizations.of(context)!.course_detail_title,
              ),
              body: Center(child: Text(provider.error!)),
            );
          }

          final courseData = provider.courseData;

          final course = courseData?['course'] ?? null;
          final teacher = courseData?['teacher'] ?? null;

          if (courseData == null) {
            return Scaffold(
              appBar: CustomAppBar(
                title: AppLocalizations.of(context)!.course_detail_title,
              ),
              body: Center(child: Text('Course not found')),
            );
          }

          bool isVerified = (authProvider.student?.status == "ACCEPTED");
          bool isPurchased = provider.hasPurchasedCourse(course['id']);

          return Scaffold(
            backgroundColor: AppColor.appBgColor,
            appBar: CustomAppBar(
              title: AppLocalizations.of(context)!
                  .course_detail_title, // Null check here
            ),
            body: RefreshIndicator(
                child: course == null || teacher == {}
                    ? Center(child: Text('No course data'))
                    : Column(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Course Image
                                  Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      // Course Image
                                      Container(
                                        height: 200,
                                        width: double.infinity,
                                        child: CourseImage(
                                          thumbnailUrl:
                                              course['chapters'] != null &&
                                                      course['chapters']
                                                          .isNotEmpty &&
                                                      course['chapters'][0]
                                                              ['thumbnail'] !=
                                                          null
                                                  ? course['chapters'][0]
                                                      ['thumbnail']['url']
                                                  : null,
                                          iconUrl: course['icon'] != null
                                              ? course['icon']['url']
                                              : null,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 200,
                                          borderRadius: 0,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16),

                                  // Course Info Section
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          course['title'],
                                          style: TextStyle(
                                            fontSize: 26,
                                            fontWeight: FontWeight.w600,
                                            color: AppColor.darker,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    TeacherView(
                                                        teacherId:
                                                            teacher['id']),
                                              ),
                                            );
                                          },
                                          child: Row(children: [
                                            Container(
                                              width: 60,
                                              height: 60,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white,
                                                border: Border.all(
                                                  color: Colors.white,
                                                  width: 2,
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withValues(alpha: 0.1),
                                                    spreadRadius: 1,
                                                    blurRadius: 5,
                                                    offset: Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                child: teacher != null &&
                                                        teacher.isNotEmpty &&
                                                        teacher['user'] !=
                                                            null &&
                                                        teacher['user'][
                                                                'profilePic'] !=
                                                            null
                                                    ? Image.network(
                                                        teacher['user']
                                                                ['profilePic']
                                                            ['url'],
                                                        fit: BoxFit.cover,
                                                      )
                                                    : Icon(
                                                        Icons.person_2_rounded,
                                                        color: AppColor.primary,
                                                      ), // Icon when null
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              (teacher != null &&
                                                          teacher.isNotEmpty &&
                                                          teacher['user'] !=
                                                              null &&
                                                          teacher['user'][
                                                                  'firstName'] !=
                                                              null &&
                                                          teacher['user'][
                                                                  'lastName'] !=
                                                              null // VERY IMPORTANT: Check for null AND empty map, then for inner keys
                                                      ? '${teacher['user']['firstName']} ${teacher['user']['lastName']}'
                                                      : 'Teacher Name Not Available') +
                                                  ' | ',
                                              // Default text
                                              style: TextStyle(
                                                  color: AppColor.textColor,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              decoration: BoxDecoration(
                                                  color: AppColor.secondary
                                                      .withValues(alpha: 0.3),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(12))),
                                              child: Text(
                                                TranslationHelper
                                                    .getTranslatedSubject(
                                                        context,
                                                        teacher['subject']),
                                                style: TextStyle(
                                                    color: Colors.purple),
                                              ),
                                            )
                                          ]),
                                        ),
                                        SizedBox(height: 12),
                                        _buildCourseStats(context, course),
                                        SizedBox(height: 25),
                                        Row(children: [
                                          Spacer(),
                                          CardFb1(
                                            text: AppLocalizations.of(context)!
                                                .enrolled_students,
                                            imageUrl:
                                                "assets/images/students.png",
                                            subtitle:
                                                course["currentEnrollment"]
                                                    .toString(),
                                            onPressed: () {},
                                          ),
                                          Spacer(),
                                          CardFb1(
                                            text: AppLocalizations.of(context)!
                                                .number_of_chapters,
                                            imageUrl: "assets/images/video.png",
                                            subtitle: provider
                                                .courseChapters.length
                                                .toString(),
                                            onPressed: () {},
                                          ),
                                          Spacer(),
                                        ]),
                                        SizedBox(height: 20),
                                        _buildAboutSection(context, course),
                                        SizedBox(height: 12),
                                        _buildCourseDetails(context, course),
                                        SizedBox(height: 16),
                                        Text(
                                          AppLocalizations.of(context)!
                                              .chapters,
                                          style: TextStyle(
                                              color: AppColor.mainColor,
                                              fontSize: 22,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Chapters List
                                  ...(provider.courseChapters.isNotEmpty
                                      ? provider.courseChapters.map((chapter) {
                                          final title = chapter
                                              .title; // Access via the field, no ['title']
                                          final thumbnail = chapter
                                              .thumbnail; // Thumbnail is an object
                                          final imageUrl = thumbnail
                                              .url; // Access url from Thumbnail// Convert duration to a string

                                          return Container(
                                            color: Colors.white70,
                                            padding: EdgeInsets.symmetric(
                                                vertical: 12, horizontal: 12),
                                            child: GestureDetector(
                                              onTap: () {
                                                if (isPurchased) {
                                                  Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute<dynamic>(
                                                      maintainState: true,
                                                      builder: (context) =>
                                                          ViewChapterScreen(
                                                              chapterId: chapter
                                                                  .id
                                                                  .toString(),
                                                              // Convert ID to string if needed
                                                              courseId:
                                                                  course['id'],
                                                              chapter: chapter),
                                                    ),
                                                  );
                                                } else {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return DialogFb3(
                                                        imgUrl: imageUrl,
                                                        title: title,
                                                        text:
                                                            chapter.description,
                                                      );
                                                    },
                                                  );
                                                }
                                              },
                                              child: LikeListTile(
                                                imgUrl: imageUrl,
                                                title: title,
                                                likes: chapter.views.toString(),
                                                color: AppColor.primary,
                                                subtitle: Helpers
                                                    .formatHoursAndMinutes(
                                                        context,
                                                        chapter.duration),
                                              ),
                                            ),
                                          );
                                        }).toList()
                                      : [
                                          // If no chapters exist
                                          Center(
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .no_chapters_available,
                                              style: TextStyle(
                                                color: AppColor.darker,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ]),
                                ],
                              ),
                            ),
                          ),

                          // Price Section
                          !isVerified
                              ? Container(
                                  padding: const EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    color: AppColor.cardColor,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColor.shadowColor
                                            .withValues(alpha: 0.1),
                                        offset: const Offset(0, -4),
                                        blurRadius: 10,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.warning,
                                        color: Colors.yellow,
                                      ),
                                      const SizedBox(width: 8.0),
                                      Expanded(
                                        child: Text(
                                          AppLocalizations.of(context)!
                                              .account_not_verified,
                                          style: TextStyle(
                                            color: AppColor.mainColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : provider.isLoadingCourses
                                  ? Container()
                                  : isPurchased
                                      ? Container(
                                          // No SafeArea if course is purchased
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 12),
                                          decoration: BoxDecoration(
                                            color: AppColor.cardColor,
                                            boxShadow: [
                                              BoxShadow(
                                                color: AppColor.shadowColor
                                                    .withValues(alpha: 0.1),
                                                offset: const Offset(0, -4),
                                                blurRadius: 10,
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    AppLocalizations.of(
                                                            context)!
                                                        .already_purchased, // Purchased text
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: AppColor.darker,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              GradientButton(
                                                text: AppLocalizations.of(
                                                        context)!
                                                    .watch,
                                                // Add your localization key or hardcoded text
                                                variant: 'primary',
                                                // Variant setting (e.g., primary style)
                                                color: Colors.white,
                                                // Text or icon color
                                                onTap: () {
                                                  Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute<dynamic>(
                                                      maintainState: true,
                                                      builder: (context) =>
                                                          ViewChapterScreen(
                                                              chapterId: provider
                                                                  .courseChapters[
                                                                      0]
                                                                  .id,
                                                              courseId:
                                                                  course['id'],
                                                              chapter: provider
                                                                  .courseChapters[0]),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        )
                                      : SafeArea(
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 12),
                                            decoration: BoxDecoration(
                                              color: AppColor.cardColor,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: AppColor.shadowColor
                                                      .withValues(alpha: 0.1),
                                                  offset: Offset(0, -4),
                                                  blurRadius: 10,
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .price_label,
                                                      style: TextStyle(
                                                          color: AppColor
                                                              .mainColor),
                                                    ),
                                                    Text(
                                                      'DZD ${course['price']}',
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: AppColor.darker,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                GradientButton(
                                                  text: context
                                                          .watch<
                                                              CourseProvider>()
                                                          .isLoading
                                                      ? AppLocalizations.of(
                                                              context)!
                                                          .loading // Show "Loading..." when in progress
                                                      : context
                                                              .watch<
                                                                  CourseProvider>()
                                                              .isSuccess
                                                          ? AppLocalizations.of(
                                                                  context)!
                                                              .loading // Show "Enrolled" when successful
                                                          : AppLocalizations.of(
                                                                  context)!
                                                              .buy_now, // Default "Buy Now" text
                                                  variant: 'primary',
                                                  color: Colors.white,
                                                  onTap: context
                                                              .watch<
                                                                  CourseProvider>()
                                                              .isLoading ||
                                                          context
                                                              .watch<
                                                                  CourseProvider>()
                                                              .isSuccess
                                                      ? () {} // Disable button if loading or enrollment is already successful
                                                      : () async {
                                                          final courseProvider =
                                                              context.read<
                                                                  CourseProvider>();
                                                          final courseId =
                                                              courseProvider
                                                                      .courseData?[
                                                                  'course']['id'];

                                                          // Trigger enrollment and redirection
                                                          final response =
                                                              await courseProvider
                                                                  .enrollAndRedirect(
                                                                      context,
                                                                      courseId);

                                                          if (response ==
                                                              true) {
                                                            courseProvider
                                                                .resetSuccess();
                                                          }
                                                        },
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                        ],
                      ),
                onRefresh: () => _refreshCourseData(context)),
          );
        },
      ),
    );
  }

  Widget _buildCourseStats(BuildContext context, Map<String, dynamic> course) {
    final int lessonsCount = (course['chapters'] as List?)?.length ?? 0;
    final double rating = course['rating'] != null
        ? double.parse(course['rating'].toString())
        : 0.0;

    return Row(
      children: [
        SizedBox(width: 16),
        Icon(Icons.access_time, size: 16, color: AppColor.mainColor),
        SizedBox(width: 4),
        Text(
          Helpers.formatHoursAndMinutes(context, course['totalWatchTime']),
          style: TextStyle(color: AppColor.mainColor),
        ),
        SizedBox(width: 16),
        Icon(Icons.star, size: 16, color: AppColor.yellow),
        SizedBox(width: 4),
        Text(rating.toStringAsFixed(1),
            style: TextStyle(color: AppColor.mainColor)),
      ],
    );
  }

  Widget _buildAboutSection(BuildContext context, course) {
    bool isExpanded =
        false; // Local state variable (updated via StatefulBuilder)

    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!
                  .about_course_title, // Display course title
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: AppColor.darker,
              ),
            ),
            SizedBox(height: 4),
            AnimatedCrossFade(
              firstChild: Text(
                course['description'], // Truncated version (3 lines)
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColor.textColor,
                  height: 1.5, // Adjust line height as needed
                ),
              ),
              secondChild: Text(
                course['description'], // Full description
                style: TextStyle(
                  color: AppColor.mainColor,
                  height: 1.5,
                ),
              ),
              crossFadeState: isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: Duration(milliseconds: 200),
            ),
            SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded; // Toggle the state
                });
              },
              child: Row(
                children: [
                  Text(
                    isExpanded
                        ? AppLocalizations.of(context)!
                            .show_less // Show "show less" text
                        : AppLocalizations.of(context)!.show_more,
                    // Show "show more" text
                    style: TextStyle(
                      color: AppColor.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: AppColor.primary,
                    size: 20,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCourseDetails(
      BuildContext context, Map<String, dynamic> course) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow(
            context,
            Icons.school,
            AppLocalizations.of(context)!.course_class,
            TranslationHelper.getTranslatedClass(
              context,
              (course['class'] as List?)?.first?.toString(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
      BuildContext context, IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColor.mainColor),
        SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            color: AppColor.mainColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: AppColor.darker,
          ),
        ),
      ],
    );
  }
}
