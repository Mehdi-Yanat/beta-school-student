class Announcement {
  final Teacher teacher;
  final String message;
  final totalCount;
  final DateTime? createdAt; // Make nullable

  Announcement({
    required this.teacher,
    required this.message,
    this.totalCount,
    this.createdAt,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      teacher: Teacher.fromJson(json['teacher']),
      message: json['message'] ?? '',
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }
}

class Teacher {
  final int id;
  final String firstName;
  final String lastName;
  final ProfilePic? profilePic;

  Teacher({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.profilePic,
  });

  String get fullName => '$firstName $lastName';

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json['id'],
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      profilePic: json['profilePic'] != null
          ? ProfilePic.fromJson(json['profilePic'])
          : null,
    );
  }
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
}
