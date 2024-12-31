class MyCourse {
  final int id;
  final DateTime enrolledAt;
  final Course course;

  MyCourse({
    required this.id,
    required this.enrolledAt,
    required this.course,
  });

  // Factory constructor for JSON deserialization
  factory MyCourse.fromJson(Map<String, dynamic> json) {
    return MyCourse(
      id: json['id'],
      enrolledAt: DateTime.parse(json['enrolledAt']),
      course: Course.fromJson(json['course']),
    );
  }

  // Method to serialize the model back to JSON
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "enrolledAt": enrolledAt.toIso8601String(),
      "course": course.toJson(),
    };
  }
}

class Course {
  final String id;
  final String title;
  final String description;
  final int price;
  final int totalWatchTime;
  final Icon icon;
  final List<Chapter> chapters;
  final Teacher teacher;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.totalWatchTime,
    required this.icon,
    required this.chapters,
    required this.teacher,
  });

  // Factory constructor for JSON deserialization
  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: json['price'],
      totalWatchTime: json['totalWatchTime'],
      icon: Icon.fromJson(json['icon']),
      chapters: (json['chapters'] as List)
          .map((chapter) => Chapter.fromJson(chapter))
          .toList(),
      teacher: Teacher.fromJson(json['teacher']),
    );
  }

  // Method to serialize the model back to JSON
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "price": price,
      "totalWatchTime": totalWatchTime,
      "icon": icon.toJson(),
      "chapters": chapters.map((c) => c.toJson()).toList(),
      "teacher": teacher.toJson(),
    };
  }
}

class Icon {
  final String url;

  Icon({required this.url});

  factory Icon.fromJson(Map<String, dynamic> json) {
    return Icon(
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "url": url,
    };
  }
}

class Chapter {
  final int id;
  final String title;
  final String description;
  final Icon thumbnail;

  Chapter({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnail,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      thumbnail: Icon.fromJson(json['thumbnail']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "thumbnail": thumbnail.toJson(),
    };
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
