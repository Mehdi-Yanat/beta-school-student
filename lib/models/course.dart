import 'package:online_course/utils/constant.dart';

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

  Teacher({
    required this.id,
    required this.userId,
    required this.subject,
    required this.institution,
    required this.yearsOfExperience,
    required this.status,
    this.description,
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
      teacherId: json['teacherId'],
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
