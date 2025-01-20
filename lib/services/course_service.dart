import 'package:http_interceptor/http_interceptor.dart';
import 'package:online_course/main.dart';
import 'package:online_course/utils/auth_interceptor.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

import '../models/chapter.dart';

class CourseService {
  static final String baseUrl = dotenv.env['API_URL'] ?? '';

  static final _client = InterceptedClient.build(
    interceptors: [AuthInterceptor()],
    requestTimeout: Duration(seconds: 60),
  );

  static String getCurrentLocale() {
    return MyApp.currentLocale.value.languageCode;
  }

  static Map<String, String> _headers() {
    return {
      'Content-Type': 'application/json',
      'Accept-Language': getCurrentLocale(),
    };
  }

  static Future<Map<String, dynamic>> getSuggestedCourses({
    String? title,
    String? subject,
    String? teacherClass,
    String? educationalBranch,
    int? limit = 10,
    int? page = 1,
  }) async {
    try {
      final queryParams = {
        if (title != null) 'title': title,
        if (subject != null) 'subject': subject,
        if (teacherClass != null) 'teacherClass': teacherClass,
        if (educationalBranch != null) 'educationalBranch': educationalBranch,
        'limit': limit.toString(),
        'page': page.toString(),
      };

      final uri = Uri.parse('$baseUrl/course/all/suggestions')
          .replace(queryParameters: queryParams);

      final response = await _client.get(
        uri,
        headers: _headers(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'courses': data ?? [],
          'total': data.length,
        };
      }
      return {'courses': [], 'total': 0, 'page': 1, 'limit': 10};
    } catch (e) {
      print('❌ Error getting courses: $e');
      return {'courses': [], 'total': 0, 'page': 1, 'limit': 10};
    }
  }

  // Get all courses
  static Future<Map<String, dynamic>> getCourses({
    String? title,
    String? subject,
    String? teacherClass,
    String? educationalBranch,
    int? limit = 10,
    int? page = 1,
  }) async {
    try {
      final queryParams = {
        if (title != null) 'title': title,
        if (subject != null) 'subject': subject,
        if (teacherClass != null) 'teacherClass': teacherClass,
        if (educationalBranch != null) 'educationalBranch': educationalBranch,
        'limit': limit.toString(),
        'page': page.toString(),
      };

      final uri = Uri.parse('$baseUrl/course/accepted')
          .replace(queryParameters: queryParams);

      final response = await _client.get(
        uri,
        headers: _headers(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'courses': data['courses'] ?? [],
          'total': data['totalCount'] ?? 0,
        };
      }
      return {'courses': [], 'total': 0, 'page': 1, 'limit': 10};
    } catch (e) {
      print('❌ Error getting courses: $e');
      return {'courses': [], 'total': 0, 'page': 1, 'limit': 10};
    }
  }

  // Get course by id
  static Future<Map<String, dynamic>?> getCourse(String courseId) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/course/$courseId?lng=${getCurrentLocale()}'),
        headers: _headers(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      }
      return null;
    } catch (e) {
      print('Error getting course: $e');
      return null;
    }
  } // Get chapter details by chapterId

  static Future<Map<String, dynamic>?> viewChapter(chapterId) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/chapter/view/$chapterId'),
        headers: _headers(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data; // The chapter details, including presigned video URL
      }
      return null;
    } catch (e) {
      print('Error getting chapter: $e');
      return null;
    }
  }

  static Future<List<Chapter>> getChaptersForCourse(String courseId) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/chapter/course/$courseId'),
        headers: _headers(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Convert JSON into a list of Chapter objects
        return (data['chapters'] as List)
            .map((json) => Chapter.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      print('Error getting chapters for course: $e');
      return [];
    }
  }

  // Get enrolled courses
  static Future<List<dynamic>> getEnrolledCourses() async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/student/course?lng=${getCurrentLocale()}'),
        headers: _headers(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data'] ?? [];
      }
      return [];
    } catch (e) {
      print('Error getting enrolled courses: $e');
      return [];
    }
  }

  // Enroll in a course
  static Future<String?> enrollCourse(String courseId) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/course/$courseId/enroll?lng=${getCurrentLocale()}'),
        headers: _headers(),
      );

      if (response.statusCode == 200) {
        //  Successful response - Extract the paymentUrl
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        return responseBody[
            'paymentUrl']; // ✅ Return the paymentUrl from the response
      } else {
        //  Something went wrong - Log the status code
        print('❌ Failed to enroll in course: ${response.statusCode}');
        return null; // Return null to indicate failure
      }
    } catch (e) {
      //  Handle unexpected errors
      print('⚠️ Error enrolling in course: $e');
      return null; // 🚫 Return null if an exception occurs
    }
  }

  // Get course progress
  static Future<Map<String, dynamic>?> getCourseProgress(
      String courseId) async {
    try {
      final response = await _client.get(
        Uri.parse(
            '$baseUrl/student/course/$courseId/progress?lng=${getCurrentLocale()}'),
        headers: _headers(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data'];
      }
      return null;
    } catch (e) {
      print('Error getting course progress: $e');
      return null;
    }
  }

  // Update course progress
  static Future<bool> updateCourseProgress(
      String courseId, String lessonId) async {
    try {
      final response = await _client.post(
        Uri.parse(
            '$baseUrl/student/course/$courseId/progress?lng=${getCurrentLocale()}'),
        headers: _headers(),
        body: jsonEncode({'lessonId': lessonId}),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error updating course progress: $e');
      return false;
    }
  }

  static Future<Map<String, dynamic>?> checkChapterIsRated(
      int chapterId) async {
    try {
      final response = await _client.get(
          Uri.parse(
              '$baseUrl/chapter/rating/check/${chapterId}?lng=${getCurrentLocale()}'),
          headers: _headers());
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      }
      return null;
    } catch (e) {
      print('Error updating course progress: $e');
      throw e;
    }
  }

  static Future<Map<String, dynamic>?> rateChapter(
      int chapterId, bool rating) async {
    try {
      final response = await _client.put(
          Uri.parse(
              '$baseUrl/chapter/rating/${chapterId}/${rating ? 1 : 0}?lng=${getCurrentLocale()}'),
          headers: _headers());
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      }
      return null;
    } catch (e) {
      print('Error updating course progress: $e');
      throw e;
    }
  }
}
