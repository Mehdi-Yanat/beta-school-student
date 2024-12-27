import 'package:flutter/material.dart';
import '../models/course.dart';
import '../services/course_service.dart';

class CourseProvider with ChangeNotifier {
  List<Course> _courses = [];
  bool _isLoading = false;
  Map<String, dynamic>? _courseData;
  String? _error;
  int _currentPage = 1;
  int _totalPages = 1;
  String? _searchQuery;
  String? _selectedSubject;
  String? _selectedClass;
  String? _selectedBranch;

  Map<String, dynamic>? get courseData => _courseData;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Course> get courses => _courses;
  // Getters
  bool get hasMore => _currentPage < _totalPages;
  String? get searchQuery => _searchQuery;
  String? get selectedSubject => _selectedSubject;
  String? get selectedClass => _selectedClass;
  String? get selectedBranch => _selectedBranch;

  List<dynamic> get courseChapters =>
      (_courseData?['course'] as Map<String, dynamic>?)?['chapters']
          as List<dynamic>? ??
      [];

  Future<void> fetchCourses({
    bool refresh = false,
    Map<String, dynamic>? filters,
  }) async {
    if (refresh) {
      _currentPage = 1;
      _courses = [];
    }

    try {
      _isLoading = true;
      notifyListeners();

      final result = await CourseService.getCourses(
        title: _searchQuery,
        subject: filters?['subject'] ?? _selectedSubject,
        teacherClass: filters?['teacherClass'] ?? _selectedClass,
        educationalBranch: filters?['educationalBranch'] ?? _selectedBranch,
        page: _currentPage,
      );

      final newCourses = (result['courses'] as List?)
              ?.map((data) => Course.fromJson(data))
              .toList() ??
          [];

      if (refresh) {
        _courses = newCourses;
      } else {
        _courses.addAll(newCourses);
      }

      // Handle null values with defaults
      final total = (result['total'] as num?)?.toInt() ?? 0;
      final limit = (result['limit'] as num?)?.toInt() ?? 10;

      _totalPages = limit > 0 ? (total / limit).ceil() : 1;
      _currentPage++;
      _error = null;
    } catch (e) {
      _error = e.toString();
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

  void setFilters({
    String? subject,
    String? teacherClass,
    String? educationalBranch,
    String? searchQuery,
    refresh = false,
  }) {
    _selectedSubject = subject;
    _selectedClass = teacherClass;
    _selectedBranch = educationalBranch;
    _searchQuery = searchQuery;
    fetchCourses(refresh: true);
  }

  void clearFilters() {
    _selectedSubject = null;
    _selectedClass = null;
    _selectedBranch = null;
    _searchQuery = null;
    fetchCourses(refresh: true);
  }
}
