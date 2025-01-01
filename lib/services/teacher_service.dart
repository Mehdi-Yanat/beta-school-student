import 'package:http_interceptor/http_interceptor.dart';
import 'package:online_course/main.dart';
import 'package:online_course/utils/auth_interceptor.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class TeacherService {
  static final String baseUrl = dotenv.env['API_URL'] ?? '';

  static final _client = InterceptedClient.build(
    interceptors: [AuthInterceptor()],
    requestTimeout: Duration(seconds: 10),
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

  // Get accepted teachers
  static Future<List<dynamic>> getAcceptedTeachers() async {
    try {
      print('🔵 Fetching accepted teachers...');
      final response = await _client.get(
        Uri.parse('$baseUrl/teacher/accepted?lng=${getCurrentLocale()}'),
        headers: _headers(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null && data['users'] != null) {
          return data['users'];
        }
        print('⚠️ No users data found in response');
        return [];
      }
      print('⚠️ Non-200 status code: ${response.statusCode}');
      return [];
    } catch (e) {
      print('❌ Error getting teachers: $e');
      return [];
    }
  }

  // Get teacher by ID
  static Future<Map<String, dynamic>?> getTeacher(int teacherId) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/teacher/$teacherId?lng=${getCurrentLocale()}'),
        headers: _headers(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      }
      return null;
    } catch (e) {
      print('❌ Error getting teacher: $e');
      return null;
    }
  }

  // Get teacher courses
  static Future<List<dynamic>> getTeacherCourses(int teacherId) async {
    try {
      final response = await _client.get(
        Uri.parse(
            '$baseUrl/teacher/$teacherId/courses?lng=${getCurrentLocale()}'),
        headers: _headers(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data'] ?? [];
      }
      return [];
    } catch (e) {
      print('❌ Error getting teacher courses: $e');
      return [];
    }
  }

  static Future<List<dynamic>> getTeacherAnnoucement(int teacherId) async {
    try {
      final response = await _client.get(
        Uri.parse(
            '$baseUrl/teacher/$teacherId/courses?lng=${getCurrentLocale()}'),
        headers: _headers(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data'] ?? [];
      }
      return [];
    } catch (e) {
      print('❌ Error getting teacher courses: $e');
      return [];
    }
  }
}
