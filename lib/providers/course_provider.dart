import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/course.dart';
import '../services/course_service.dart';
import '../widgets/snackbar.dart';

class CourseProvider with ChangeNotifier {
  List<Course> _courses = [];
  Map<String, dynamic>? _currentChapter;
  Map<String, dynamic>?
      _currentVideo; // Holds the video information (including URL)// Add currentChapter
  bool _isLoading = false;
  Map<String, dynamic>? _courseData;
  String? _error;
  int _currentPage = 1;
  int _totalPages = 1;
  String? _searchQuery;
  String? _selectedSubject;
  String? _selectedClass;
  String? _selectedBranch;
  bool _isSuccess = false;

  Map<String, dynamic>? get courseData => _courseData;

  Map<String, dynamic>? get currentVideo => _currentVideo;

  bool get isLoading => _isLoading;

  bool get isSuccess => _isSuccess;

  String? get error => _error;

  List<Course> get courses => _courses;

  // Getters
  bool get hasMore => _currentPage < _totalPages;

  String? get searchQuery => _searchQuery;

  String? get selectedSubject => _selectedSubject;

  String? get selectedClass => _selectedClass;

  String? get selectedBranch => _selectedBranch;

  Map<String, dynamic>? get currentChapter => _currentChapter;

  // Setter for currentChapter
  void setCurrentChapter(Map<String, dynamic> chapter) {
    _currentChapter = chapter;
    notifyListeners(); // Notify listeners that the current chapter has changed
  }

  void setCurrentVideo(Map<String, dynamic>? video) {
    _currentVideo = video;
    notifyListeners(); // Notify the listeners that the video has changed
  }

  void resetSuccess() {
    _isSuccess = false;
    notifyListeners(); // Notify listeners to update the UI
  }

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
          'course': Map<String, dynamic>.from(data['course'] as Map? ?? {}),
          'teacher': Map<String, dynamic>.from(data['teacher'] as Map? ?? {}),
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

  Future enrollAndRedirect(BuildContext context, String courseId) async {
    try {
      _isLoading = true; // Set loading to true
      _isSuccess = false; // Reset success state
      notifyListeners(); // Notify listeners to update the UI

      // Make API call to enroll the course and get the payment URL
      final paymentUrl = await CourseService.enrollCourse(courseId);

      if (paymentUrl != null) {
        // 🎉 Payment URL is returned - Try redirecting to the payment page
        if (await canLaunchUrl(Uri.parse(paymentUrl))) {
          await launchUrl(
            Uri.parse(paymentUrl),
          );

          // Set success state to true after successful redirection
          _isSuccess = true;

          return true;
        } else {
          throw Exception('Cannot launch payment URL: $paymentUrl');
        }
      } else {
        // ❌ Enrollment failed - Payment URL is null
        throw Exception('Enrollment failed, payment URL not provided.');
      }
    } catch (e) {
      // Show error message in a SnackBar
      SnackBarHelper.showErrorSnackBar(
        context,
        e.toString(),
      );

      // Debugging: Log the error details for developers
      debugPrint(
          '❌ Exception during course enrollment and payment redirection: $e');
    } finally {
      _isLoading = false; // Set loading to false regardless of success/failure
      notifyListeners(); // Notify listeners to update the UI
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
