import 'package:flutter/material.dart';
import 'package:online_course/models/teacher.dart';
import 'package:online_course/services/teacher_service.dart';

class TeacherProvider with ChangeNotifier {
  List<Teacher> _teachers = [];
  bool _isLoading = false;

  List<Teacher> get teachers => _teachers;
  bool get isLoading => _isLoading;

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
}
