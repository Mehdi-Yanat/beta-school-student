import 'package:online_course/models/chapter.dart' as ChapterModel;

class MyCourse {
  final int id;
  final DateTime enrolledAt;
  final Course course;

  MyCourse({
    required this.id,
    required this.enrolledAt,
    required this.course,
  });

  factory MyCourse.fromJson(Map<String, dynamic> json) {
    return MyCourse(
      id: json['id'] ?? 0,
      enrolledAt: json['enrolledAt'] != null
          ? DateTime.parse(json['enrolledAt'])
          : DateTime.now(),
      course: Course.fromJson(json['course'] ?? {}),
    );
  }
}

class Course {
  final String id;
  final String title;
  final String description;
  final double price;
  final int totalWatchTime;
  final CourseIcon? icon;
  final List<Chapter> chapters;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.totalWatchTime,
    this.icon,
    required this.chapters,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      totalWatchTime: json['totalWatchTime'] ?? 0,
      icon: json['icon'] != null ? CourseIcon.fromJson(json['icon']) : null,
      chapters: (json['chapters'] as List?)
              ?.map((x) => Chapter.fromJson(x))
              .toList() ??
          [],
    );
  }
}

class CourseIcon {
  final String url;

  CourseIcon({required this.url});

  factory CourseIcon.fromJson(Map<String, dynamic> json) {
    final url = json['url'] ?? '';
    return CourseIcon(
        url: url.isNotEmpty ? url : 'assets/images/default_course.png');
  }
}

class Chapter extends ChapterModel.Chapter {
  final int id;
  final String title;
  final String description;
  final double? rating;
  final int views;
  final int duration;

  Chapter(
      {required this.id,
      required this.title,
      required this.views,
      required this.description,
      required this.duration,
      this.rating,
      required super.createdAt,
      required super.updatedAt,
      required super.thumbnail})
      : super(
            id: id,
            title: title,
            description: description,
            duration: duration,
            views: views,
            rating: rating);

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
        id: json['id'] ?? 0,
        title: json['title'] ?? '',
        description: json['description'] ?? '',
        rating: json['rating'],
        views: json['views'],
        duration: json['duration'],
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'])
            : DateTime.now(),
        updatedAt: json['updatedAt'] != null
            ? DateTime.parse(json['updatedAt'])
            : DateTime.now(),
        thumbnail: ChapterModel.Thumbnail.fromJson(json['thumbnail']));
  }
}

class Teacher {
  final int id;
  final User user;

  Teacher({
    required this.id,
    required this.user,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json['id'],
      user: User.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "user": user.toJson(),
    };
  }
}

class User {
  final int id;
  final String firstName;
  final String lastName;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "firstName": firstName,
      "lastName": lastName,
    };
  }
}
