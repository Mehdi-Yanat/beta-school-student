import 'package:online_course/models/course.dart';

class ProfilePic {
  final int id;
  final String fileName;
  final String url;

  ProfilePic({
    required this.id,
    required this.fileName,
    required this.url,
  });

  factory ProfilePic.fromJson(Map<String, dynamic> json) {
    return ProfilePic(
      id: json['id'],
      fileName: json['fileName'],
      url: json['url'],
    );
  }
}

class IconData {
  final int id;
  final String fileName;
  final String url;

  IconData({
    required this.id,
    required this.fileName,
    required this.url,
  });

  factory IconData.fromJson(Map<String, dynamic> json) {
    return IconData(
      id: json['id'],
      fileName: json['fileName'],
      url: json['url'],
    );
  }
}

class TeacherInfo {
  final int id;
  final int userId;
  final String subject;
  final String institution;
  final int yearsOfExperience;
  final String status;
  final String? description;
  final List<Course> courses;

  TeacherInfo({
    required this.id,
    required this.userId,
    required this.subject,
    required this.institution,
    required this.yearsOfExperience,
    required this.status,
    this.description,
    required this.courses,
  });

  factory TeacherInfo.fromJson(Map<String, dynamic> json) {
    return TeacherInfo(
      id: json['id'],
      userId: json['userId'],
      subject: json['subject'],
      institution: json['institution'],
      yearsOfExperience: json['yearsOfExperience'],
      status: json['status'],
      description: json['description'],
      courses: (json['Course'] as List? ?? [])
          .map((c) => Course.fromJson(c))
          .toList(),
    );
  }
}
