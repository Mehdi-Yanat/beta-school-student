import 'package:flutter/material.dart';
import 'package:online_course/models/teacher.dart';
import 'package:online_course/services/teacher_service.dart';

class TeacherProvider with ChangeNotifier {
  List<Teacher> _teachers = [];
  Map<String, dynamic>? _teacherData;
  String? _error;

  bool _isLoading = false;

  Map<String, dynamic>? get teacher => _teacherData;
  List<Teacher> get teachers => _teachers;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<dynamic> get courses =>
      (_teacherData?['user']["Teacher"] as Map<String, dynamic>?)?['Course']
          as List<dynamic>? ??
      [];

  Future<void> fetchTeachers() async {
    try {
      _isLoading = true;
      notifyListeners();

      final teachersData = await TeacherService.getAcceptedTeachers();
      _teachers = teachersData.map((data) => Teacher.fromJson(data)).toList();
      print('✅ Fetched ${_teachers.length} teachers');
    } catch (e) {
      print('❌ Error fetching teachers: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchTeacher(teacherId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final data = await TeacherService.getTeacher(teacherId);
      if (data != null) {
        _teacherData = {
          'user': Map<String, dynamic>.from(data['user'] as Map),
        };

        print('✅ Course data fetched successfully');
        print('📝 Course chapters: ${courses.length}');
      } else {
        _error = 'Failed to fetch course data';
      }
    } catch (e, stack) {
      print('❌ Error fetching course: $e');
      print('📍 Stack trace: $stack');
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
