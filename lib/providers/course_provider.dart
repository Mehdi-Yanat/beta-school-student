import 'package:flutter/material.dart';
import '../models/course.dart';
import '../services/course_service.dart';

class CourseProvider with ChangeNotifier {
  List<Course> _courses = [];
  bool _isLoading = false;

  List<Course> get courses => _courses;
  bool get isLoading => _isLoading;

   Future<void> fetchCourses() async {
    try {
      _isLoading = true;
      notifyListeners();
  
      final coursesData = await CourseService.getCourses();
      _courses = coursesData.map((data) => Course.fromJson(data)).toList();
      print('✅ Fetched ${_courses.length} courses');
    } catch (e) {
      print('❌ Error fetching courses: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
