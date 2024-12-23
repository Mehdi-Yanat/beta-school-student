import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:online_course/utils/storage.dart';
import 'dart:convert';
import '../models/student.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http_parser/http_parser.dart';

class AuthResult {
  final bool success;
  final String message;
  AuthResult(this.success, this.message);
}

class AuthService {
  static final String baseUrl = dotenv.env['API_URL'] ?? '';

  // Register student
  static Future<bool> registerStudent(Student student,
      {String lang = 'ar'}) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/auth/student/register'),
      );

      // Add text fields
      request.fields['email'] = student.email;
      request.fields['password'] = student.password ?? '';
      request.fields['firstName'] = student.firstName;
      request.fields['lastName'] = student.lastName;
      request.fields['firstNameAr'] = student.firstNameAr ?? '';
      request.fields['lastNameAr'] = student.lastNameAr ?? '';
      request.fields['address'] = student.address ?? '';
      request.fields['phone'] = student.phone ?? '';
      request.fields['wilaya'] = student.wilaya;
      request.fields['class'] = student.studentClass;

      // Add photo if exists
      final profilePic = student.profilePic;
      if (profilePic != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'profilePic',
            profilePic,
            contentType: MediaType('image', 'jpeg'),
          ),
        );
      }

      final response = await request.send();
      return response.statusCode == 201;
    } catch (e) {
      print('Registration error: $e');
      return false;
    }
  }

  // Login function
  static Future<AuthResult> login(String email, String password,
      {String lang = 'ar'}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login?lng=$lang'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final String message = responseData['message'] ?? 'Unknown error';

      if (response.statusCode == 200) {
        final String accessToken =
            responseData['tokens']['access']['token'] ?? '';
        final String refreshToken =
            responseData['tokens']['refresh']['token'] ?? '';
        await StorageService.saveToken("accessToken", accessToken);
        await StorageService.saveToken("refreshToken", refreshToken);

        return AuthResult(true, message);
      } else {
        return AuthResult(false, message);
      }
    } catch (e) {
      return AuthResult(false, e.toString());
    }
  }

  // Verify the token
  static Future<Map<String, dynamic>?> verifyToken(String token,
      {String lang = 'ar'}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/student/me?lng=$lang'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          return data['data']; // Return student data
        }
      }
      return null; // Invalid token or failed response
    } catch (e) {
      print('Error verifying token: $e');
      return null;
    }
  }

  static Future<AuthResult> updateProfile(
    String token,
    Student student, {
    String lang = 'ar',
    File? newProfilePic,
  }) async {
    try {
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse('$baseUrl/student/me?lng=$lang'),
      );

      // Add auth header
      request.headers['Authorization'] = 'Bearer $token';

      // Add text fields
      request.fields['firstName'] = student.firstName;
      request.fields['lastName'] = student.lastName;
      request.fields['firstNameAr'] = student.firstNameAr ?? '';
      request.fields['lastNameAr'] = student.lastNameAr ?? '';
      request.fields['address'] = student.address ?? '';
      request.fields['phone'] = student.phone ?? '';
      request.fields['wilaya'] = student.wilaya;
      request.fields['class'] = student.studentClass;

      // Add new photo if provided
      if (newProfilePic != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'profilePic',
            newProfilePic.path,
            contentType: MediaType('image', 'jpeg'),
          ),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final String message = responseData['message'] ?? 'Unknown error';

      return AuthResult(response.statusCode == 200, message);
    } catch (e) {
      return AuthResult(false, e.toString());
    }
  }
}
