import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import localization
import 'package:online_course/providers/course_provider.dart';
import 'package:online_course/theme/color.dart';
import 'package:online_course/utils/translation.dart';
import 'package:online_course/widgets/course_image.dart';
import 'package:online_course/widgets/gradient_button.dart';
import 'package:provider/provider.dart';
import '../../widgets/appbar.dart';

class CourseDetailScreen extends StatelessWidget {
  final String courseId;

  const CourseDetailScreen({Key? key, required this.courseId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CourseProvider()..fetchCourse(courseId),
      child: Consumer<CourseProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
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
          if (courseData == null) {
            return Scaffold(
              appBar: CustomAppBar(
                title: AppLocalizations.of(context)!.course_detail_title,
              ),
              body: Center(child: Text('Course not found')),
            );
          }

          final course = courseData['course'];
          final teacher = courseData['teacher'];

          return Scaffold(
            backgroundColor: AppColor.appBgColor,
            appBar: CustomAppBar(
              title: course['title'],
            ),
            body: Column(
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
                                thumbnailUrl: (course['chapters'] as List)
                                        .isNotEmpty
                                    ? course['chapters'][0]['thumbnail']['url']
                                    : null,
                                iconUrl: course['icon']['url'],
                                width: MediaQuery.of(context).size.width,
                                height: 200,
                                borderRadius: 0,
                              ),
                            ),

                            // Teacher Profile Picture
                            Positioned(
                              bottom: -30,
                              right: Directionality.of(context) ==
                                      TextDirection.rtl
                                  ? null
                                  : 30,
                              left: Directionality.of(context) ==
                                      TextDirection.rtl
                                  ? 30
                                  : null,
                              child: Container(
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
                                      color:
                                          Colors.black.withValues(alpha: 0.1),
                                      spreadRadius: 1,
                                      blurRadius: 5,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: teacher['user']['profilePic'] != null
                                      ? Image.network(
                                          teacher['user']['profilePic']['url'],
                                          fit: BoxFit.cover,
                                        )
                                      : Icon(
                                          Icons.person,
                                          size: 30,
                                          color: AppColor.mainColor,
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),

                        // Course Info Section
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                course['title'],
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.darker,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                '${teacher['user']['firstName']} ${teacher['user']['lastName']}',
                                style: TextStyle(color: AppColor.mainColor),
                              ),
                              SizedBox(height: 8),
                              _buildCourseStats(
                                  context, provider.courseChapters.length),
                              SizedBox(height: 12),
                              _buildCourseDetails(context, course),
                              SizedBox(height: 12),
                              _buildAboutSection(context, course),
                            ],
                          ),
                        ),
                        SizedBox(height: 16),

                        // Chapters List
                        ...provider.courseChapters
                            .map((chapter) => CourseLessonItem(
                                  title: chapter['title'],
                                  duration: '${provider.courseChapters.length} ${AppLocalizations.of(context)!.chapters}',
                                  imagePath: chapter['thumbnail']['url'],
                                ))
                            .toList(),
                      ],
                    ),
                  ),
                ),

                // Price Section
                SafeArea(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColor.cardColor,
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.shadowColor.withValues(alpha: 0.1),
                          offset: Offset(0, -4),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.price_label,
                              style: TextStyle(color: AppColor.mainColor),
                            ),
                            Text(
                              'DZD ${course['price']}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColor.darker,
                              ),
                            ),
                          ],
                        ),
                        GradientButton(
                          text: AppLocalizations.of(context)!.buy_now,
                          variant: 'primary',
                          color: Colors.white,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCourseStats(BuildContext context, int length) {
    return Row(
      children: [
        Icon(Icons.video_library, size: 16, color: AppColor.mainColor),
        SizedBox(width: 4),
        Text(
          AppLocalizations.of(context)!.course_lessons(6),
          style: TextStyle(color: AppColor.mainColor),
        ),
        SizedBox(width: 16),
        Icon(Icons.access_time, size: 16, color: AppColor.mainColor),
        SizedBox(width: 4),
        Text(
          AppLocalizations.of(context)!.course_duration("10"),
          style: TextStyle(color: AppColor.mainColor),
        ),
        SizedBox(width: 16),
        Icon(Icons.star, size: 16, color: AppColor.yellow),
        SizedBox(width: 4),
        Text('4.5', style: TextStyle(color: AppColor.mainColor)),
      ],
    );
  }

  Widget _buildAboutSection(BuildContext context, course) {
    final descriptionKey = GlobalKey();
    return StatefulBuilder(
      builder: (context, setState) {
        bool isExpanded = false;
        bool isOverflowing = false;

        // Check if text overflows
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (descriptionKey.currentContext != null) {
            final RenderBox renderBox =
                descriptionKey.currentContext!.findRenderObject() as RenderBox;
            final TextPainter painter = TextPainter(
              text: TextSpan(
                text: course['description'],
                style: TextStyle(
                  color: AppColor.mainColor,
                  height: 1.5,
                ),
              ),
              maxLines: 3,
              textDirection: TextDirection.ltr,
            )..layout(maxWidth: renderBox.size.width);

            setState(() {
              isOverflowing = painter.didExceedMaxLines;
            });
          }
        });

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              course['title'],
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColor.darker,
              ),
            ),
            SizedBox(height: 4),
            AnimatedCrossFade(
              firstChild: Text(
                course['description'],
                key: descriptionKey,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColor.mainColor,
                  height: 1.5,
                ),
              ),
              secondChild: Text(
                course['description'],
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
            if (isOverflowing) ...[
              SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                child: Row(
                  children: [
                    Text(
                      isExpanded
                          ? AppLocalizations.of(context)!.show_less
                          : AppLocalizations.of(context)!.show_more,
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
            Icons.grade,
            AppLocalizations.of(context)!.course_level,
            TranslationHelper.getTranslatedLevel(context, course['level']),
          ),
          SizedBox(height: 8),
          _buildDetailRow(
            context,
            Icons.language,
            AppLocalizations.of(context)!.course_language,
            course['language'] ?? AppLocalizations.of(context)!.not_specified,
          ),
          SizedBox(height: 8),
          _buildDetailRow(
            context,
            Icons.school,
            AppLocalizations.of(context)!.course_class,
            TranslationHelper.getTranslatedClass(
              context,
              (course['class'] as List?)?.first?.toString(),
            ),
          ),
          SizedBox(height: 8),
          _buildDetailRow(
            context,
            Icons.category,
            AppLocalizations.of(context)!.course_branch,
            TranslationHelper.getTranslatedBranch(
              context,
              (course['EducationalBranch'] as List?)?.first?.toString(),
            ),
          ),
          if (course['maxParticipants'] != null) ...[
            SizedBox(height: 8),
            _buildDetailRow(
              context,
              Icons.group,
              AppLocalizations.of(context)!.course_max_participants,
              course['maxParticipants'].toString(),
            ),
          ],
          if (course['enrollmentDeadline'] != null) ...[
            SizedBox(height: 8),
            _buildDetailRow(
              context,
              Icons.event,
              AppLocalizations.of(context)!.course_enrollment_deadline,
              DateTime.parse(course['enrollmentDeadline'])
                  .toString()
                  .split(' ')[0],
            ),
          ],
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
          color: AppColor.darker,
        ),
      ),
      subtitle: Text(duration, style: TextStyle(color: AppColor.mainColor)),
    );
  }
}
