import 'package:http_interceptor/http_interceptor.dart';
import 'package:online_course/main.dart';
import 'package:online_course/utils/auth_interceptor.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

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

  // Get all courses
  static Future<List<dynamic>> getCourses() async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/course/accepted?lng=${getCurrentLocale()}'),
        headers: _headers(),
      );
  
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['courses'] ?? [];
      }
      return [];
    } catch (e) {
      print('❌ Error getting courses: $e');
      return [];
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
        return data['data'];
      }
      return null;
    } catch (e) {
      print('Error getting course: $e');
      return null;
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
  static Future<bool> enrollCourse(String courseId) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/student/course/enroll?lng=${getCurrentLocale()}'),
        headers: _headers(),
        body: jsonEncode({'courseId': courseId}),
      );

      return response.statusCode == 201;
    } catch (e) {
      print('Error enrolling in course: $e');
      return false;
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
}
