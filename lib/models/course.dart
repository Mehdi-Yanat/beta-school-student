import 'package:online_course/models/shared.dart';
import 'package:online_course/utils/constant.dart';

class TeacherUser {
  final String firstName;
  final String lastName;
  final String email;
  final IconData? profilePic;

  TeacherUser({
    required this.firstName,
    required this.lastName,
    required this.email,
    this.profilePic,
  });

  factory TeacherUser.fromJson(Map<String, dynamic> json) {
    return TeacherUser(
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      profilePic: json['profilePic'] != null
          ? IconData.fromJson(json['profilePic'])
          : null,
    );
  }
}

class Chapter {
  final int id;
  final String courseId;
  final String title;
  final String description;
  final int videoFileId;
  final int thumbnailId;
  final int views;
  final double? rating;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int duration;
  final IconData? thumbnail;

  Chapter({
    required this.id,
    required this.courseId,
    required this.title,
    required this.description,
    required this.videoFileId,
    required this.thumbnailId,
    required this.views,
    this.rating,
    required this.createdAt,
    required this.updatedAt,
    required this.duration,
    this.thumbnail,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      id: json['id'],
      courseId: json['courseId'],
      title: json['title'],
      description: json['description'],
      videoFileId: json['videoFileId'],
      thumbnailId: json['thumbnailId'],
      views: json['views'],
      rating: json['rating']?.toDouble(),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      duration: json['duration'],
      thumbnail: json['thumbnail'] != null
          ? IconData.fromJson(json['thumbnail'])
          : null,
    );
  }
}

class Teacher {
  final int id;
  final int userId;
  final String subject;
  final String institution;
  final int yearsOfExperience;
  final String status;
  final String? description;
  final TeacherUser user;

  Teacher({
    required this.id,
    required this.userId,
    required this.subject,
    required this.institution,
    required this.yearsOfExperience,
    required this.status,
    this.description,
    required this.user,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json['id'],
      userId: json['userId'],
      subject: json['subject'],
      institution: json['institution'],
      yearsOfExperience: json['yearsOfExperience'],
      status: json['status'],
      description: json['description'],
      user: TeacherUser.fromJson(json['user']),
    );
  }
}

class Course {
  final String id;
  final String handle;
  final String title;
  final String description;
  final int price;
  final int? discount;
  final int teacherId;
  final IconData? icon;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? duration;
  final String? language;
  final CourseLevel level;
  final int? maxParticipants;
  final int? currentEnrollment;
  final DateTime? enrollmentDeadline;
  final List<String> classes;
  final List<String> branches;
  final List<Chapter> chapters;
  final CourseStatus status;
  final String? statusNote;
  final Teacher teacher;

  Course({
    required this.id,
    required this.handle,
    required this.title,
    required this.description,
    required this.price,
    this.discount,
    required this.teacherId,
    this.icon,
    required this.createdAt,
    required this.updatedAt,
    this.duration,
    this.language,
    required this.level,
    this.maxParticipants,
    this.currentEnrollment,
    this.enrollmentDeadline,
    required this.classes,
    required this.branches,
    required this.chapters,
    required this.status,
    this.statusNote,
    required this.teacher,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      handle: json['handle'],
      title: json['title'],
      description: json['description'],
      price: json['price'],
      discount: json['discount'],
      teacherId: json['teacher']['id'],
      icon: json['icon'] != null ? IconData.fromJson(json['icon']) : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      duration: json['duration'],
      language: json['language'],
      level: CourseLevel.values.firstWhere(
        (e) => e.toString() == 'CourseLevel.${json['level']}',
        orElse: () => CourseLevel.BEGINNER,
      ),
      maxParticipants: json['maxParticipants'],
      currentEnrollment: json['currentEnrollment'],
      enrollmentDeadline: json['enrollmentDeadline'] != null
          ? DateTime.parse(json['enrollmentDeadline'])
          : null,
      classes: List<String>.from(json['class'] ?? []),
      branches: List<String>.from(json['EducationalBranch'] ?? []),
      chapters: (json['chapters'] as List? ?? [])
          .map((c) => Chapter.fromJson(c))
          .toList(),
      status: CourseStatus.values.firstWhere(
        (e) => e.toString() == 'CourseStatus.${json['status']}',
        orElse: () => CourseStatus.PENDING,
      ),
      statusNote: json['statusNote'],
      teacher: Teacher.fromJson(json['teacher']),
    );
  }

  @override
  String toString() {
    return 'Course{id: $id, title: $title}';
  }
}
