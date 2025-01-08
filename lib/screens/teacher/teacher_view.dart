import 'package:flutter/material.dart';
import 'package:online_course/providers/teacher_provider.dart';
import 'package:online_course/screens/course/course_detail.dart';
import 'package:online_course/theme/color.dart';
import 'package:online_course/widgets/appbar.dart';
import 'package:online_course/widgets/course_card.dart';
import 'package:provider/provider.dart';
import 'package:online_course/utils/translation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../widgets/CardFb1.dart';
import '../../widgets/StarRating.dart'; // Import localization

class TeacherView extends StatelessWidget {
  final int teacherId;

  const TeacherView({Key? key, required this.teacherId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TeacherProvider()..fetchTeacher(teacherId),
      child: Consumer<TeacherProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          final teacher = provider.teacher;
          if (teacher == null) {
            return Scaffold(
              body: Center(child: Text('Teacher not found')),
            );
          }

          final description = teacher['description'];
          final user = teacher['user'];
          final courses = user['Teacher']['Course'] as List;

          return Scaffold(
            backgroundColor: AppColor.appBgColor,
            appBar: CustomAppBar(
              title: AppLocalizations.of(context)!.teacher_info,
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  // Profile Header
                  _buildProfileHeader(context, user),

                  // Subject & Institution
                  _buildTeacherInfo(context, teacher['teacher']),

                  // About Teacher Section
                  _buildAboutTeacherSection(context, description),

                  // Stats Section
                  _buildStatsSection(context, teacher['teacher'], courses.length),

                  // Course Grid
                  _buildCourseGrid(context, courses),

                  SizedBox(height: 16),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, Map<String, dynamic> user) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(60),
              child: user['profilePic'] != null
                  ? Image.network(
                      user['profilePic']['url'],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.person,
                        size: 60,
                        color: AppColor.mainColor,
                      ),
                    )
                  : Icon(
                      Icons.person,
                      size: 60,
                      color: AppColor.mainColor,
                    ),
            ),
          ),
          SizedBox(width: 16),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (user['firstNameAr'] != null && user['lastNameAr'] != null)
                Text(
                  '${user['firstNameAr']} '
                      '${user['lastNameAr']}',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColor.darker,
                  ),
                  textAlign: TextAlign.start,
                ),
              Text(
                '${user['firstName'][0].toUpperCase()}${user['firstName'].substring(1).toLowerCase()} '
                    '${user['lastName'][0].toUpperCase()}${user['lastName'].substring(1).toLowerCase()}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: AppColor.darker,
                ),
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 15,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StarRating(color: AppColor.yellow, starCount: 5, rating: 3.9, size: 22,),
                  const SizedBox(width: 10,),
                  Text(
                    "3.9",
                    style: TextStyle(
                      fontWeight: FontWeight.w600
                    ),
                  )
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(
    BuildContext context,
    Map<String, dynamic> teacher,
    int courseCount,
  ) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Left: Years Experience
          _buildStatItem(
            context,
            Icons.work,
            '${teacher['yearsOfExperience'].toString()}',
            AppLocalizations.of(context)!.years_experience,
          ),
          // Center: Course Count
          CardFb1(
            text: AppLocalizations.of(context)!.courses_count,
            imageUrl: "assets/images/video.png",
            subtitle: '$courseCount',
            onPressed: () {},
          ),
          // Right: Students Count
          _buildStatItem(
            context,
            Icons.people,
            '${teacher['totalEnrolledStudents'].toString()}',
            AppLocalizations.of(context)!.students_count,
          ),
        ],
      ),
    );
  }

  /// Displays the "About Teacher" Section
  Widget _buildAboutTeacherSection(BuildContext context, String? description) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        color: AppColor.primary.withAlpha(120)
      ),
      alignment: AlignmentDirectional.topStart,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Section Title
          Text(
            textAlign: TextAlign.start,
            AppLocalizations.of(context)!.about_teacher, // Localized title
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w600,
              color: AppColor.darker,
            ),
          ),
          const SizedBox(height: 8),
          // Description Content
          if (description != null && description.isNotEmpty)
            Text(
              textAlign: TextAlign.start,
              description,
              style: const TextStyle(
                color: AppColor.mainColor,
                height: 1.5,
              ),
            )
          else
            Text(
              AppLocalizations.of(context)!.no_description_available,
              // Fallback text
              style: const TextStyle(
                color: AppColor.mainColor,
                fontStyle: FontStyle.italic,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTeacherInfo(
    BuildContext context,
    Map<String, dynamic> teacher,
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.subject, color: AppColor.mainColor),
              Text(AppLocalizations.of(context)!.class_label + ": ", style: TextStyle(fontWeight: FontWeight.w500),),
              SizedBox(width: 8),
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
,
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.business, color: AppColor.mainColor),
              SizedBox(width: 8),
              Text(
                teacher['institution'] ??
                    AppLocalizations.of(context)!.institution_unknown,
                style: TextStyle(
                  color: AppColor.mainColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.people_alt_rounded, color: AppColor.mainColor),
              Text(AppLocalizations.of(context)!.students_count + ": ", style: TextStyle(fontWeight: FontWeight.w500),),
              SizedBox(width: 8),
              Text(
                teacher['totalEnrolledStudents'].toString().isEmpty ?
                    AppLocalizations.of(context)!.institution_unknown : teacher['totalEnrolledStudents'].toString(),
                style: TextStyle(
                  color: AppColor.mainColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCourseGrid(BuildContext context, List courses) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.courses,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColor.darker,
            ),
          ),
          SizedBox(height: 16),
          if (courses.isEmpty)
            Center(
              child: Text(
                AppLocalizations.of(context)!.no_courses_found,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColor.mainColor,
                ),
              ),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
              itemCount: courses.length,
              itemBuilder: (context, index) => CourseCard(
                course: courses[index],
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CourseDetailScreen(courseId: courses[index]['id']),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    IconData icon,
    String value,
    String label,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, color: AppColor.mainColor),
        SizedBox(height: 4, width: 70),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColor.darker,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: AppColor.mainColor,
          ),
        ),
      ],
    );
  }
}
