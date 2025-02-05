class Student {
  final String? id;
  final String email;
  final String? password;
  final String firstName;
  final String lastName;
  final String? firstNameAr;
  final String? lastNameAr;
  final String? address;
  final String? phone;
  final String wilaya;
  final String studentClass;
  final String? profilePic;
  final isEmailVerified;
  final String? status; // Maps to 'data.Student.status'
  final totalWatchTimeInHours;
  final totalWatchTimeInSeconds;

  Student({
    this.id,
    required this.email,
    this.password,
    required this.firstName,
    required this.lastName,
    this.firstNameAr,
    this.lastNameAr,
    this.address,
    this.phone,
    required this.wilaya,
    required this.studentClass,
    this.profilePic,
    this.isEmailVerified,
    this.status,
    this.totalWatchTimeInHours,
    this.totalWatchTimeInSeconds,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      firstName: json['firstName']?.toString() ?? '',
      lastName: json['lastName']?.toString() ?? '',
      firstNameAr: json['firstNameAr']?.toString(),
      lastNameAr: json['lastNameAr']?.toString(),
      address: json['Student']?['address']?.toString(),
      phone: json['phone']?.toString(),
      wilaya: json['Student']?['wilaya']?.toString() ?? '',
      studentClass: json['Student']?['class']?.toString() ?? '',
      profilePic: json['profilePic']?['url']?.toString(),
      isEmailVerified: json['isEmailVerified'],
      status: json['Student']?['status']?.toString() ??
          '', // Maps to 'Student.status'
      totalWatchTimeInSeconds: json['totalWatchTimeInSeconds'] ?? 0,
      totalWatchTimeInHours: json['totalWatchTimeInHours'] ?? 0,
    );
  }
}
