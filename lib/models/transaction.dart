class Transaction {
  final String id;
  final int studentId;
  final String courseId;
  final String status;
  final double amount;
  final double discount;
  final double netAmount;
  final String paymentUrl;
  final String? invoiceId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? paidAt;
  final String? paymentMethod;
  final bool deleted;
  final Course course;

  Transaction({
    required this.id,
    required this.studentId,
    required this.courseId,
    required this.status,
    required this.amount,
    required this.discount,
    required this.netAmount,
    required this.paymentUrl,
    this.invoiceId,
    required this.createdAt,
    required this.updatedAt,
    this.paidAt,
    this.paymentMethod,
    required this.deleted,
    required this.course,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      studentId: json['studentId'],
      courseId: json['courseId'],
      status: json['status'],
      amount: json['amount'].toDouble(),
      discount: json['discount'].toDouble(),
      netAmount: json['netAmount'].toDouble(),
      paymentUrl: json['paymentUrl'],
      invoiceId: json['invoiceId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      paidAt: json['paidAt'] != null ? DateTime.parse(json['paidAt']) : null,
      paymentMethod: json['paymentMethod'],
      deleted: json['deleted'],
      course: Course.fromJson(json['course']),
    );
  }
}

class Course {
  final String id;
  final String title;
  final String description;
  final double price;
  final Teacher teacher;
  final CourseIcon icon;
  final List<Chapter> chapters; // New field for chapters
  final int totalWatchTime;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.teacher,
    required this.icon,
    required this.chapters,
    required this.totalWatchTime,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: json['price'].toDouble(),
      teacher: Teacher.fromJson(json['teacher']),
      icon: CourseIcon.fromJson(json['icon']),
      chapters: (json['chapters'] as List<dynamic>)
          .map((chapter) => Chapter.fromJson(chapter))
          .toList(),
      totalWatchTime: json['totalWatchTime'],
    );
  }
}

class Teacher {
  final String firstName;
  final String lastName;
  final String email;

  Teacher({
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      firstName: json['user']['firstName'],
      lastName: json['user']['lastName'],
      email: json['user']['email'],
    );
  }
}

class CourseIcon {
  final int id;
  final String fileName;
  final String url;

  CourseIcon({
    required this.id,
    required this.fileName,
    required this.url,
  });

  factory CourseIcon.fromJson(Map<String, dynamic> json) {
    return CourseIcon(
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
  final int? rating;
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
      rating: json['rating'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      duration: json['duration'],
    );
  }
}
