// Profile Picture Model
class File {
  final int? id;
  final String fileName;
  final String url;

  File({
    required this.id,
    required this.fileName,
    required this.url,
  });

  factory File.fromJson(Map<String, dynamic> json) {
    return File(
      id: json['id'],
      fileName: json['fileName'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fileName': fileName,
      'url': url,
    };
  }
}

// Chapter Model
class Chapter {
  final int id;
  final File thumbnail;

  Chapter({
    required this.id,
    required this.thumbnail,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      id: json['id'],
      thumbnail: File.fromJson(json['thumbnail']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'thumbnail': thumbnail.toJson(),
    };
  }
}

// User Model
class User {
  final String firstName;
  final String lastName;
  final String lastNameAr;
  final String firstNameAr;
  final File? profilePic;

  User({
    required this.firstName,
    required this.lastName,
    required this.lastNameAr,
    required this.firstNameAr,
    this.profilePic,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      firstName: json['firstName'],
      lastName: json['lastName'],
      lastNameAr: json['lastNameAr'],
      firstNameAr: json['firstNameAr'],
      profilePic: json['profilePic'] != null
          ? File.fromJson(json['profilePic'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'lastNameAr': lastNameAr,
      'firstNameAr': firstNameAr,
      'profilePic': profilePic?.toJson(),
    };
  }
}

// Teacher Model
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

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
    };
  }
}

// Course Model
class FeaturedCourse {
  final String id;
  final String status;
  final String handle;
  final String title;
  final String description;
  final int price;
  final int? discount;
  final int teacherId;
  final int? iconId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String subject;
  final double rating;
  final int? duration;
  final String? language;
  final String level;
  final int? maxParticipants;
  final int currentEnrollment;
  final DateTime? enrollmentDeadline;
  final List<String> classLevels;
  final List<String> educationalBranches;
  final int totalWatchTime;
  final String? statusNote;
  final bool deleted;
  final Teacher teacher;
  final File? icon;
  final double balanceScore;
  final List<Chapter>? chapters;

  FeaturedCourse({
    required this.id,
    required this.status,
    required this.handle,
    required this.title,
    required this.description,
    required this.price,
    required this.discount,
    required this.teacherId,
    this.iconId,
    required this.createdAt,
    required this.updatedAt,
    required this.subject,
    required this.rating,
    this.duration,
    this.language,
    required this.level,
    this.maxParticipants,
    required this.currentEnrollment,
    this.enrollmentDeadline,
    required this.classLevels,
    required this.educationalBranches,
    required this.totalWatchTime,
    this.statusNote,
    required this.deleted,
    required this.teacher,
    this.icon,
    required this.balanceScore,
    required this.chapters,
  });

  factory FeaturedCourse.fromJson(Map<String, dynamic> json) {
    return FeaturedCourse(
      id: json['id'],
      status: json['status'],
      handle: json['handle'],
      title: json['title'],
      description: json['description'],
      price: json['price'],
      discount: json['discount'],
      teacherId: json['teacherId'],
      iconId: json['iconId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      subject: json['subject'],
      rating: json['rating'].toDouble(),
      duration: json['duration'],
      language: json['language'],
      level: json['level'],
      maxParticipants: json['maxParticipants'],
      currentEnrollment: json['currentEnrollment'],
      enrollmentDeadline: json['enrollmentDeadline'] != null
          ? DateTime.parse(json['enrollmentDeadline'])
          : null,
      classLevels: List<String>.from(json['class']),
      educationalBranches: List<String>.from(json['EducationalBranch']),
      totalWatchTime: json['totalWatchTime'],
      statusNote: json['statusNote'],
      deleted: json['deleted'],
      teacher: Teacher.fromJson(json['teacher']),
      icon: json['icon'] != null
          ? File.fromJson(json['icon'])
          : null,
      balanceScore: json['balanceScore'].toDouble(),
      chapters: (json['chapters'] as List<dynamic>)
          .map((chapterJson) => Chapter.fromJson(chapterJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'handle': handle,
      'title': title,
      'description': description,
      'price': price,
      'discount': discount,
      'teacherId': teacherId,
      'iconId': iconId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'subject': subject,
      'rating': rating,
      'duration': duration,
      'language': language,
      'level': level,
      'maxParticipants': maxParticipants,
      'currentEnrollment': currentEnrollment,
      'enrollmentDeadline': enrollmentDeadline?.toIso8601String(),
      'class': classLevels,
      'EducationalBranch': educationalBranches,
      'totalWatchTime': totalWatchTime,
      'statusNote': statusNote,
      'deleted': deleted,
      'teacher': teacher.toJson(),
      'icon': icon,
      'balanceScore': balanceScore,
      'chapters': chapters?.map((chapter) => chapter.toJson()).toList(),
    };
  }
}
