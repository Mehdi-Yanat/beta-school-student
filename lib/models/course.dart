import 'package:online_course/utils/constant.dart';

class ImageData {
  final String? url;
  final String? fileName;

  ImageData({this.url, this.fileName});

  factory ImageData.fromJson(Map<String, dynamic>? json) {
    if (json == null) return ImageData(); // Return default if json is null

    return ImageData(
      url: json['url'],
      fileName: json['fileName'],
    );
  }
}

class TeacherUser {
  final String? firstName; //Make these nullable for more safety
  final String? lastName;
  final String? firstNameAr; //Make these nullable for more safety
  final String? lastNameAr;
  final String? email;
  final ImageData? profilePic; // Use ImageData

  TeacherUser({
    required this.firstName,
    required this.lastName,
    required this.firstNameAr,
    required this.lastNameAr,
    required this.email,
    this.profilePic,
  });

  factory TeacherUser.fromJson(Map<String, dynamic>? json) {
    if (json == null)
      return TeacherUser(
          firstName: null,
          lastName: null,
          firstNameAr: null,
          lastNameAr: null,
          email: null,
          profilePic: null); // Handle null json

    return TeacherUser(
      firstName: json['firstName'],
      lastName: json['lastName'],
      firstNameAr: json['firstNameAr'],
      lastNameAr: json['lastNameAr'],
      email: json['email'],
      profilePic:
          ImageData.fromJson(json['profilePic']), // Correctly create ImageData
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
  final ImageData? thumbnail; //Use ImageData instead of IconData

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
      thumbnail: ImageData.fromJson(json['thumbnail']),
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
  final ImageData? icon; // Use ImageData
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? duration;
  final String? language;
  final CourseLevel level;
  final int? maxParticipants;
  final int? currentEnrollment;
  final int? totalWatchTime;
  final DateTime? enrollmentDeadline;
  final List<String> classes;
  final List<String> branches;
  final List<Chapter> chapters;
  final CourseStatus status;
  final String? statusNote;
  final Teacher teacher;
  final String? subject;
  final double? rating;

  Course( {
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
    this.totalWatchTime,
    this.enrollmentDeadline,
    required this.classes,
    required this.branches,
    required this.chapters,
    required this.status,
    this.statusNote,
    this.subject,
    required this.teacher,
    this.rating,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    if (json['teacher'] != null) {
      return Course(
        id: json['id'],
        handle: json['handle'],
        title: json['title'],
        description: json['description'],
        price: json['price'],
        discount: json['discount'],
        teacherId: json['teacher'] != null ? (json['teacher']['id'] ?? 0) : 0,
        icon: ImageData.fromJson(json['icon']), // Correctly create ImageData
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
        totalWatchTime: json['totalWatchTime'],
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
        subject: json['subject'],
        teacher: Teacher.fromJson(json['teacher']),
        rating: json['rating'] != null ? json['rating'].toDouble() : null,
      );
    } else {
      return Course(
        id: '',
        handle: '',
        title: '',
        description: '',
        price: 0,
        teacherId: 0,
        totalWatchTime: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        classes: [],
        branches: [],
        chapters: [],
        status: CourseStatus.PENDING,
        teacher: Teacher(
          id: 0,
          userId: 0,
          subject: '',
          institution: '',
          yearsOfExperience: 0,
          status: '',
          user: TeacherUser(
            firstName: '',
            lastName: '',
            firstNameAr: '',
            lastNameAr: '',
            email: '',
            profilePic: ImageData(),
          ),
        ),
        level: CourseLevel.BEGINNER,
      );
    }
  }

  @override
  String toString() {
    return 'Course{id: $id, title: $title}';
  }
}
