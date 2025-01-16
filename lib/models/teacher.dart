import 'package:online_course/models/course.dart';
import 'package:online_course/models/shared.dart';

class TeacherInfo {
  final int id;
  final int userId;
  final String subject;
  final String institution;
  final int yearsOfExperience;
  final int totalEnrolledStudents;
  final String status;
  final String? description;
  final List<Course> courses;

  TeacherInfo({
    required this.id,
    required this.userId,
    required this.subject,
    required this.institution,
    required this.yearsOfExperience,
    required this.totalEnrolledStudents,
    required this.status,
    this.description,
    required this.courses,
  });

  factory TeacherInfo.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      print('❌ TeacherInfo JSON is null');
      return TeacherInfo(
        id: 0,
        userId: 0,
        subject: '',
        institution: '',
        totalEnrolledStudents: 0,
        yearsOfExperience: 0,
        status: '',
        description: null,
        courses: [],
      );
    }

    try {
      print('📝 Parsing TeacherInfo: ${json['id']}');

      final coursesList = json['Course'] as List<dynamic>?;
      final parsedCourses = coursesList
              ?.map((courseJson) {
                try {
                  return Course.fromJson(courseJson as Map<String, dynamic>);
                } catch (e) {
                  print('❌ Error parsing course: $e');
                  return null;
                }
              })
              .where((course) => course != null)
              .cast<Course>()
              .toList() ??
          <Course>[];

      return TeacherInfo(
        id: json['id'] ?? 0,
        userId: json['userId'] ?? 0,
        subject: json['subject'] ?? '',
        institution: json['institution'] ?? '',
        totalEnrolledStudents: json['totalEnrolledStudents'] ?? 0,
        yearsOfExperience: json['yearsOfExperience'] ?? 0,
        status: json['status'] ?? '',
        description: json['description'],
        courses: parsedCourses,
      );
    } catch (e) {
      print('❌ Error in TeacherInfo.fromJson: $e');
      print('🔍 Raw JSON: $json');
      rethrow;
    }
  }
}

class FeaturedTeacher {
  final int id;
  final String fullName;
  final String? fullNameAr;
  final String email;
  final String? profilePic;
  final String subject;
  final String institution;
  final int yearsOfExperience;
  final String? description;
  final FeaturedTeacherStats stats;
  final double score;

  FeaturedTeacher({
    required this.id,
    required this.fullName,
    this.fullNameAr,
    required this.email,
    this.profilePic,
    required this.subject,
    required this.institution,
    required this.yearsOfExperience,
    this.description,
    required this.stats,
    required this.score,
  });

  factory FeaturedTeacher.fromJson(Map<String, dynamic> json) {
    return FeaturedTeacher(
      id: json['id'] ?? 0,
      fullName: json['fullName'] ?? '',
      fullNameAr: json['fullNameAr'],
      email: json['email'] ?? '',
      profilePic: json['profilePic'] ,
      subject: json['subject'] ?? '',
      institution: json['institution'] ?? '',
      yearsOfExperience: json['yearsOfExperience'] ?? 0,
      description: json['description'],
      stats: FeaturedTeacherStats.fromJson(json['stats'] ?? {}),
      score: (json['score'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class FeaturedTeacherStats {
  final double rating;
  final int totalCourses;
  final int totalEnrolledStudents;
  final int totalActiveCourses;

  FeaturedTeacherStats({
    required this.rating,
    required this.totalCourses,
    required this.totalEnrolledStudents,
    required this.totalActiveCourses,
  });

  factory FeaturedTeacherStats.fromJson(Map<String, dynamic> json) {
    return FeaturedTeacherStats(
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      totalCourses: json['totalCourses'] ?? 0,
      totalEnrolledStudents: json['totalEnrolledStudents'] ?? 0,
      totalActiveCourses: json['totalActiveCourses'] ?? 0,
    );
  }
}

class Teacher {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String? firstNameAr;
  final String? lastNameAr;
  final String phone;
  final String role;
  final ProfilePic? profilePic;
  final bool isEmailVerified;
  final DateTime createdAt;
  final DateTime updatedAt;
  final TeacherInfo teacherInfo;

  Teacher({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.firstNameAr,
    this.lastNameAr,
    required this.phone,
    required this.role,
    this.profilePic,
    required this.isEmailVerified,
    required this.createdAt,
    required this.updatedAt,
    required this.teacherInfo,
  });

  factory Teacher.fromJson(Map<String, dynamic>? json) {
    if (json == null) throw Exception('Teacher JSON data is null');

    try {
      return Teacher(
        id: json['Teacher']['id'] ?? 0,
        email: json['email'] ?? '',
        firstName: json['firstName'] ?? '',
        lastName: json['lastName'] ?? '',
        firstNameAr: json['firstNameAr'],
        lastNameAr: json['lastNameAr'],
        phone: json['phone'] ?? '',
        role: json['role'] ?? '',
        profilePic: json['profilePic'] != null
            ? ProfilePic.fromJson(json['profilePic'] as Map<String, dynamic>)
            : null,
        isEmailVerified: json['isEmailVerified'] ?? false,
        createdAt: DateTime.parse(
            json['createdAt'] ?? DateTime.now().toIso8601String()),
        updatedAt: DateTime.parse(
            json['updatedAt'] ?? DateTime.now().toIso8601String()),
        teacherInfo:
            TeacherInfo.fromJson(json['Teacher'] as Map<String, dynamic>),
      );
    } catch (e, stack) {
      print('❌ Error parsing teacher data: $e\n$stack');
      print('🔍 JSON data: $json');
      rethrow;
    }
  }
}
