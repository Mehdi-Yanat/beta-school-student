import 'package:flutter/material.dart';
import 'package:online_course/theme/color.dart';
import 'package:online_course/widgets/appbar.dart';

class TeacherView extends StatelessWidget {
  final int teacherId;

  static final Map<String, dynamic> mockTeacher = {
    "id": 1,
    "subject": "Mathematics",
    "institution": "Beta Prime School",
    "yearsOfExperience": 5,
    "status": "ACCEPTED",
    "description":
        "Experienced mathematics teacher specializing in secondary education with a focus on algebra and calculus. Passionate about making complex concepts easy to understand.",
    "user": {
      "id": 1,
      "firstName": "John",
      "lastName": "Smith",
      "phone": "0555123456",
      "profilePic": null,
      "Teacher": {
        "Course": [
          {"id": 1, "title": "Advanced Algebra"},
          {"id": 2, "title": "Calculus 101"},
        ]
      }
    }
  };

  const TeacherView({Key? key, required this.teacherId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final teacher = mockTeacher;
    final user = teacher['user'];

    return Scaffold(
      backgroundColor: AppColor.appBgColor,
      appBar: CustomAppBar(
        title: '${user['firstName']} ${user['lastName']}',
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  // Profile Image
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.white,
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
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
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(
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

                  // Teacher Name
                  Text(
                    '${user['firstName']} ${user['lastName']}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColor.darker,
                    ),
                  ),
                  SizedBox(height: 8),

                  // Subject & Institution
                  Text(
                    user['subject'] ?? 'Other',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColor.mainColor,
                    ),
                  ),
                  Text(
                    user['institution'] ?? 'Unknown Institution',
                    style: TextStyle(
                      color: AppColor.mainColor,
                    ),
                  ),
                ],
              ),
            ),

            // Stats Section
            Container(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    context,
                    Icons.work,
                    '${user['yearsOfExperience']} Years',
                    'Experience',
                  ),
                  _buildStatItem(
                    context,
                    Icons.school,
                    '${user['Teacher']['Course'].length}',
                    'Courses',
                  ),
                ],
              ),
            ),

            // Description
            if (user['description'] != null && user['description'].isNotEmpty)
              Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'About',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColor.darker,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      user['description'],
                      style: TextStyle(
                        color: AppColor.mainColor,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
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
      children: [
        Icon(icon, color: AppColor.mainColor),
        SizedBox(height: 4),
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
