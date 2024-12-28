import 'package:flutter/material.dart';
import 'package:online_course/providers/teacher_provider.dart';
import 'package:online_course/screens/course/course_detail.dart';
import 'package:online_course/theme/color.dart';
import 'package:online_course/widgets/appbar.dart';
import 'package:online_course/widgets/course_card.dart';
import 'package:provider/provider.dart';
import 'package:online_course/utils/translation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import localization

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

          final user = teacher['user'];
          final courses = user['Teacher']['Course'] as List;

          return Scaffold(
            backgroundColor: AppColor.appBgColor,
            appBar: CustomAppBar(
              title: '${user['firstName']} ${user['lastName']}',
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  // Profile Header
                  _buildProfileHeader(context, user),

                  // Stats Section
                  _buildStatsSection(context, user['Teacher'], courses.length),

                  // Subject & Institution
                  _buildTeacherInfo(context, user['Teacher']),

                  // Course Grid
                  _buildCourseGrid(context, courses),

                  // About Section
                  if (teacher['description'] != null)
                    _buildAboutSection(context, teacher['description']),

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
      child: Column(
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
          SizedBox(height: 16),
          Text(
            '${user['firstName']} ${user['lastName']}',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColor.darker,
            ),
            textAlign: TextAlign.center,
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
          _buildStatItem(
            context,
            Icons.school,
            '$courseCount',
            AppLocalizations.of(context)!.courses_count,
          ),
          // Right: Students Count
          _buildStatItem(
            context,
            Icons.people,
            '0',
            AppLocalizations.of(context)!.students_count,
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
              SizedBox(width: 8),
              Text(
                TranslationHelper.getTranslatedSubject(
                  context,
                  teacher['subject'],
                ),
                style: TextStyle(
                  fontSize: 16,
                  color: AppColor.mainColor,
                ),
              ),
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

  Widget _buildAboutSection(BuildContext context, String description) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.about_teacher,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColor.darker,
            ),
          ),
          SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              color: AppColor.mainColor,
              height: 1.5,
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
