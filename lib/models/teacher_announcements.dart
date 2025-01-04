// Teacherannouncement.dart
class TeacherAnnouncementResponse {
  final List<TeacherAnnouncement> Teacherannouncements;

  TeacherAnnouncementResponse({
    required this.Teacherannouncements,
  });

  factory TeacherAnnouncementResponse.fromJson(Map<String, dynamic> json) {
    return TeacherAnnouncementResponse(
      Teacherannouncements: (json['announcements'] as List)
          .map((x) => TeacherAnnouncement.fromJson(x))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'announcements': Teacherannouncements.map((x) => x.toJson()).toList(),
      };
}

class TeacherAnnouncement {
  final int id;
  final int teacherId;
  final String message;
  final DateTime createdAt;
  final Teacher teacher;

  TeacherAnnouncement({
    required this.id,
    required this.teacherId,
    required this.message,
    required this.createdAt,
    required this.teacher,
  });

  factory TeacherAnnouncement.fromJson(Map<String, dynamic> json) {
    return TeacherAnnouncement(
      id: json['id'],
      teacherId: json['teacherId'],
      message: json['message'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      teacher: Teacher.fromJson(json['teacher']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'teacherId': teacherId,
        'message': message,
        'createdAt': createdAt?.toIso8601String(),
        'teacher': teacher.toJson(),
      };
}

class Teacher {
  final User user;

  Teacher({
    required this.user,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      user: User.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() => {
        'user': user.toJson(),
      };

  String get fullName => '${user.firstName} ${user.lastName}';
}

class User {
  final String firstName;
  final String lastName;
  final ProfilePic? profilePic;

  User({
    required this.firstName,
    required this.lastName,
    this.profilePic,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      firstName: json['firstName'],
      lastName: json['lastName'],
      profilePic: json['profilePic'] != null
          ? ProfilePic.fromJson(json['profilePic'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'profilePic': profilePic?.toJson(),
      };
}

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

  Map<String, dynamic> toJson() => {
        'id': id,
        'fileName': fileName,
        'url': url,
      };
}
