import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import localization
import 'package:online_course/models/FeaturedCourse.dart';
import 'package:online_course/models/chapter.dart' as Chapter;
import 'package:url_launcher/url_launcher.dart';
import '../models/course.dart' as Course;
import '../models/mycourses.dart' as MyCourse;
import '../services/course_service.dart';
import '../services/student_service.dart';
import '../utils/helper.dart';
import '../widgets/snackbar.dart';

class CourseProvider with ChangeNotifier {
  List<Course.Course> _courses = [];
  List<FeaturedCourse> _featuredCourses = [];

  List<Chapter.Chapter> _courseChapters = [];

  Chapter.Chapter? _currentChapter;
  Map<String, dynamic>? _currentVideo;
  Map<String, dynamic>? _currentChapterRating = null;

  Map<String, dynamic> get currentChapterRating => _currentChapterRating ?? {};

  set currentChapterRating(Map<String, dynamic>? value) {
    _currentChapterRating = value;
  }

  bool _isLoading = false;
  bool _isPending = false;
  bool _isLoadingCourses = false;
  bool _isLoadingChapter = false;
  Map<String, dynamic>? _courseData;
  String? _error;
  int _currentPage = 1;
  int _totalPages = 1;
  String _currentTransactionId = "";
  String? _searchQuery;
  String? _selectedSubject;
  String? _selectedClass;
  String? _selectedBranch;
  bool _isSuccess = false;
  List<MyCourse.MyCourse> _myCourses = [];
  Map<String, dynamic>? get courseData => _courseData;
  List<FeaturedCourse> get featuredCourses => _featuredCourses;

  set featuredCourses(List<FeaturedCourse> value) {
    _featuredCourses = value;
  }

  Map<String, dynamic>? get currentVideo => _currentVideo;

  String get currentTransactionId => _currentTransactionId;

  bool get isLoading => _isLoading;

  bool get isPending => _isPending;

  bool get isLoadingCourses => _isLoadingCourses;

  bool get isLoadingChapter => _isLoadingChapter;

  bool get isSuccess => _isSuccess;

  String? get error => _error;

  List<Course.Course> get courses => _courses;

  List<Chapter.Chapter> get courseChapters => _courseChapters;

  bool get hasMore => _currentPage < _totalPages;

  String? get searchQuery => _searchQuery;

  String? get selectedSubject => _selectedSubject;

  String? get selectedClass => _selectedClass;

  String? get selectedBranch => _selectedBranch;

  Chapter.Chapter? get currentChapter => _currentChapter;

  List<MyCourse.MyCourse> get myCourses => _myCourses;

  bool hasPurchasedCourse(String courseId) {
    return _myCourses.any((course) => course.course.id == courseId);
  }

  void setCurrentChapter(Chapter.Chapter chapter) {
    _currentChapter = chapter;
    notifyListeners();
  }

  void setCurrentVideo(Map<String, dynamic>? video) {
    _currentVideo = video;
    notifyListeners();
  }

  void resetSuccess() {
    _isSuccess = false;
    notifyListeners();
  }

  void clearCourseChapters() {
    _courseChapters = [];
    notifyListeners();
  }

  Future<void> fetchChaptersForCourse(
      String courseId, BuildContext context) async {
    final localizations = AppLocalizations.of(context)!; // Get localizations
    _isLoadingChapter = true;
    notifyListeners();

    try {
      final chapters = await CourseService.getChaptersForCourse(courseId);
      _courseChapters = chapters;
      _error = null;
    } catch (e) {
      _error = localizations.error_fetching_chapters; // Use translation key
    } finally {
      _isLoadingChapter = false;
      notifyListeners();
    }
  }

  Future<void> checkChapterIsRated(
      int chapterId, BuildContext context) async {
    final localizations = AppLocalizations.of(context)!; // Get localizations
    _isLoadingChapter = true;
    notifyListeners();

    try {
      final response = await CourseService.checkChapterIsRated(chapterId);
      _currentChapterRating = response;
    } catch (e) {
      _error = localizations.error_fetching_chapters; // Use translation key
    } finally {
      _isLoadingChapter = false;
      notifyListeners();
    }
  }

  Future<void> rateChapter(
      int chapterId, bool rating, BuildContext context) async {
    final localizations = AppLocalizations.of(context)!; // Get localizations
    _isLoadingChapter = true;
    notifyListeners();

    try {
      final response = await CourseService.rateChapter(chapterId, rating);
      SnackBarHelper.showSuccessSnackBar(context, response?['message']);
    } catch (e) {
      _error = localizations.error_fetching_chapters; // Use translation key
      SnackBarHelper.showErrorSnackBar(context, "Error rating chapter");
    } finally {
      _isLoadingChapter = false;
      notifyListeners();
    }
  }

  Future<void> fetchSuggestedCourses({
    bool refresh = false,
    Map<String, dynamic>? filters,
    required BuildContext context,
  }) async {
    final localizations = AppLocalizations.of(context)!;
    if (refresh) {
      _currentPage = 1;
      _courses = [];
    }

    try {
      _isLoading = true;
      notifyListeners();

      final result = await CourseService.getSuggestedCourses(
        title: _searchQuery,
        subject: filters?['subject'] ?? _selectedSubject,
        teacherClass: filters?['teacherClass'] ?? _selectedClass,
        educationalBranch: filters?['educationalBranch'] ?? _selectedBranch,
        page: _currentPage,
      );

      final newCourses = (result['courses'] as List?)
          ?.map((data) => FeaturedCourse.fromJson(data))
          .toList() ??
          [];

      if (refresh) {
        _featuredCourses = newCourses;
      } else {
        _featuredCourses.addAll(newCourses);
      }

      final total = (result['total'] as num?)?.toInt() ?? 0;
      final limit = (result['limit'] as num?)?.toInt() ?? 10;

      _totalPages = limit > 0 ? (total / limit).ceil() : 1;
      _currentPage++;
      _error = null;
    } catch (e) {
      _error = localizations.fetch_courses_error; // Use translation key
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  Future<void> fetchCourses({
    bool refresh = false,
    Map<String, dynamic>? filters,
    required BuildContext context,
  }) async {
    final localizations = AppLocalizations.of(context)!;
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
              ?.map((data) => Course.Course.fromJson(data))
              .toList() ??
          [];

      if (refresh) {
        _courses = newCourses;
      } else {
        _courses.addAll(newCourses);
      }

      final total = (result['total'] as num?)?.toInt() ?? 0;
      final limit = (result['limit'] as num?)?.toInt() ?? 10;

      _totalPages = limit > 0 ? (total / limit).ceil() : 1;
      _currentPage++;
      _error = null;
    } catch (e) {
      _error = localizations.fetch_courses_error; // Use translation key
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }



  Future<void> enrollByCash(BuildContext context,String courseId) async {
    bool isEnrolled = await StudentService.enrollByCash(context, courseId);

    final checkPendingTransactionResponse = await StudentService.checkCashTransaction(courseId);
    if (checkPendingTransactionResponse['status'] != null) {
      _isPending = checkPendingTransactionResponse['status'] == "PENDING";
      notifyListeners();
    }
    if (checkPendingTransactionResponse['transactionId'] != null) {
      _currentTransactionId = checkPendingTransactionResponse['transactionId'];
      notifyListeners();
    }
  }

  Future<void> cancelCashTransaction(BuildContext context,String transactionId) async {
    print(transactionId);
    bool isCancelled = await StudentService.cancelCashTransaction(context ,transactionId);

    _isPending = !isCancelled;
    notifyListeners();
  }

  Future<void> fetchCourse(String courseId, BuildContext context) async {
    final localizations = AppLocalizations.of(context)!;
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      if (courseId.isNotEmpty) {
        final checkPendingTransactionResponse = await StudentService.checkCashTransaction(courseId);
        if (checkPendingTransactionResponse['status'] != null) {
          _isPending = checkPendingTransactionResponse['status'] == "PENDING";
          notifyListeners();
        }
        if (checkPendingTransactionResponse['transactionId'] != null) {
          _currentTransactionId = checkPendingTransactionResponse['transactionId'];
          notifyListeners();
        }
      }

      final data = await CourseService.getCourse(courseId);
      if (data != null) {
        _courseData = {
          'course': Map<String, dynamic>.from(data['course'] as Map? ?? {}),
          'teacher': Map<String, dynamic>.from(data['teacher'] as Map? ?? {}),
        };

        fetchMyCourses(context);
        print(localizations.course_fetch_success); // Log success message
      } else {
        _error = localizations.course_fetch_error; // Use translation key
      }
    } catch (e) {
      _error = e.toString(); // Log technical error alongside translations
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future enrollAndRedirect(BuildContext context, String courseId) async {
    final localizations = AppLocalizations.of(context)!;

    try {
      _isLoading = true;
      _isSuccess = false;
      notifyListeners();

      final paymentUrl = await CourseService.enrollCourse(courseId);

      if (paymentUrl != null) {
        if (await canLaunchUrl(Uri.parse(paymentUrl))) {
          await launchUrl(Uri.parse(paymentUrl));
          _isSuccess = true;
          return true;
        } else {
          throw Exception(localizations.payment_redirect_failed);
        }
      } else {
        throw Exception(localizations.enrollment_payment_error);
      }
    } catch (e) {
      SnackBarHelper.showErrorSnackBar(context, e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMyCourses(BuildContext context) async {
    final localizations = AppLocalizations.of(context)!;

    try {
      _isLoadingCourses = true;
      _isLoading = true;
      notifyListeners();

      _myCourses = await StudentService.getStudentCourses();
    } catch (e) {
      print(localizations.fetch_my_courses_error); // Log error message
    } finally {
      _isLoadingCourses = false;
      _isLoading = false;
      notifyListeners();
    }
  }

  void setFiltersForSuggestedCourses(
      {String? subject,
        String? teacherClass,
        String? educationalBranch,
        String? searchQuery,
        refresh = false,
        context}) {
    _selectedSubject = subject;
    _selectedClass = teacherClass;
    _selectedBranch = educationalBranch;
    _searchQuery = searchQuery;
    fetchSuggestedCourses(refresh: true, context: context);
  }

  void setFilters(
      {String? subject,
      String? teacherClass,
      String? educationalBranch,
      String? searchQuery,
      refresh = false,
      context}) {
    _selectedSubject = subject;
    _selectedClass = teacherClass;
    _selectedBranch = educationalBranch;
    _searchQuery = searchQuery;
    fetchCourses(refresh: true, context: context);
  }

  void clearFilters(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    _selectedSubject = null;
    _selectedClass = null;
    _selectedBranch = null;
    _searchQuery = null;
    fetchCourses(refresh: true, context: context);
    print(localizations.clear_filters); // Log success message
  }

  bool isPendingCourse(BuildContext context ,String courseId) {

    return _isPending;
  }
}
