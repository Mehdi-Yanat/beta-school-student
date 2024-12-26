import 'package:flutter/material.dart';
import '../models/course.dart';
import '../services/course_service.dart';

class CourseProvider with ChangeNotifier {
  List<Course> _courses = [];
  bool _isLoading = false;
  Map<String, dynamic>? _courseData;
  String? _error;

  Map<String, dynamic>? get courseData => _courseData;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Course> get courses => _courses;

  List<dynamic> get courseChapters =>
      (_courseData?['course'] as Map<String, dynamic>?)?['chapters']
          as List<dynamic>? ??
      [];

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

  Future<void> fetchCourse(String courseId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final data = await CourseService.getCourse(courseId);
      if (data != null) {
        _courseData = {
          'course': Map<String, dynamic>.from(data['course'] as Map),
          'teacher': Map<String, dynamic>.from(data['teacher'] as Map),
        };

        print('✅ Course data fetched successfully');
        print('📝 Course chapters: ${courseChapters.length}');
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
