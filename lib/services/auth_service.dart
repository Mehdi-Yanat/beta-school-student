import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_interceptor/http_interceptor.dart';
import 'package:online_course/main.dart';
import 'package:online_course/utils/auth_interceptor.dart';
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

  static final _client = InterceptedClient.build(
    interceptors: [AuthInterceptor()],
    requestTimeout: Duration(seconds: 60),
  );

  static String getCurrentLocale() {
    return MyApp.currentLocale.value.languageCode;
  }

  static Map<String, String> _headers([String? token]) {
    return {
      'Content-Type': 'application/json',
      'Accept-Language': getCurrentLocale(),
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Register student
  static Future<bool> registerStudent(Student student,
      {String lang = 'ar'}) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/auth/student/register?lng=${getCurrentLocale()}'),
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
        Uri.parse('$baseUrl/auth/login?lng=${getCurrentLocale()}'),
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
  static Future<Map<String, dynamic>?> verifyToken({String lang = 'ar'}) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/student/me?lng=${getCurrentLocale()}'),
        headers: _headers(),
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
      final request = http.MultipartRequest(
        'PUT',
        Uri.parse('$baseUrl/student/me?lng=${getCurrentLocale()}'),
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

      final http.StreamedResponse streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final String message = responseData['message'] ?? 'Unknown error';

      return AuthResult(response.statusCode == 200, message);
    } catch (e) {
      return AuthResult(false, e.toString());
    }
  }

  static Future<AuthResult> updateEmail(String token, String email,
      {String lang = 'ar'}) async {
    try {
      final response = await _client.put(
        Uri.parse('$baseUrl/student/me?lng=${getCurrentLocale()}'),
        headers: _headers(token),
        body: jsonEncode({
          'email': email,
        }),
      );

      if (response.body.isNotEmpty) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final String message = responseData['message'] ?? 'Unknown error';
        return AuthResult(response.statusCode == 200, message);
      }

      return AuthResult(response.statusCode == 200,
          'Email update ${response.statusCode == 200 ? 'successful' : 'failed'}');
    } catch (e) {
      print('Email update error: $e');
      return AuthResult(false, e.toString());
    }
  }

  static Future<AuthResult> updatePassword(
      String token, String currentPassword, String newPassword,
      {String lang = 'ar'}) async {
    try {
      final response = await _client.put(
        Uri.parse('$baseUrl/student/me?lng=${getCurrentLocale()}'),
        headers: _headers(token),
        body: jsonEncode({
          'password': newPassword,
        }),
      );

      if (response.body.isNotEmpty) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final String message = responseData['message'] ?? 'Unknown error';
        return AuthResult(response.statusCode == 200, message);
      }

      return AuthResult(response.statusCode == 200,
          'Password update ${response.statusCode == 200 ? 'successful' : 'failed'}');
    } catch (e) {
      print('Password update error: $e');
      return AuthResult(false, e.toString());
    }
  }

  static Future<AuthResult> refreshTokens(String refreshToken) async {
    try {
      print('🔄 Starting token refresh...');
      print('📤 Using refresh token: ${refreshToken.substring(0, 10)}...');

      final response = await http.post(
        Uri.parse('$baseUrl/auth/refresh-tokens?lng=${getCurrentLocale()}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'refreshToken': refreshToken,
        }),
      );

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        // Direct access to token objects
        final String? accessToken = responseData['access']?['token'];
        final String? newRefreshToken = responseData['refresh']?['token'];

        if (accessToken != null && newRefreshToken != null) {
          print('✅ Tokens extracted successfully');
          print('📝 New access token: ${accessToken.substring(0, 10)}...');

          await Future.wait([
            StorageService.saveToken("accessToken", accessToken),
            StorageService.saveToken("refreshToken", newRefreshToken),
          ]);

          return AuthResult(true, 'Tokens refreshed successfully');
        } else {
          print('❌ Token extraction failed - tokens were null');
          return AuthResult(false, 'Invalid token format in response');
        }
      }

      print('❌ Invalid response from server');
      return AuthResult(false, 'Invalid response from server');
    } catch (e, stack) {
      print('💥 Refresh tokens error: $e');
      print('Stack trace: $stack');
      return AuthResult(false, e.toString());
    }
  }

  static Future<bool> forgotPassword(String email, {String lang = 'ar'}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/forgot-password?lng=${getCurrentLocale()}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );
      return response.statusCode == 204;
    } catch (e) {
      print('Forgot password error: $e');
      return false;
    }
  }

  static Future<bool> logout({String lang = 'ar'}) async {
    try {
      // Retrieve tokens
      final accessToken = await StorageService.getToken("accessToken");
      final refreshToken = await StorageService.getToken("refreshToken");

      if (accessToken == null) {
        // Consider already logged out if there's no access token
        return true;
      }

      // Make a logout request to the backend
      final response = await _client.post(
        Uri.parse('$baseUrl/auth/logout?lng=${getCurrentLocale()}'),
        headers: _headers(accessToken),
        body: jsonEncode({"refreshToken": refreshToken}),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        // Clear tokens from local storage
        await Future.wait([
          StorageService.deleteToken("accessToken"),
          StorageService.deleteToken("refreshToken"),
        ]);
        return true;
      } else {
        print('Logout failed: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error during logout: $e');
      return false;
    }
  }

  static Future<bool> sendEmailVerification({String lang = 'ar'}) async {
    final String token = await StorageService.getToken('accessToken') ?? '';
    try {
      final response = await _client.post(
        Uri.parse(
            '$baseUrl/auth/send-verification-email?lng=${getCurrentLocale()}'),
        headers: _headers(token), // Pass the authorization token
      );

      if (response.body.isNotEmpty) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print("responseData ${responseData}");
        return true;
      }

      return response.statusCode == 204 ? true : false;
    } catch (e) {
      print('Email verification error: $e');
      return false;
    }
  }

  static Future<bool> verifyEmail(String token, {String lang = 'ar'}) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/auth/verify-email?token=$token'),
        headers: {
          ..._headers(), // Include existing headers
          'Accept-Language': lang, // Pass the language for localization
        },
      );

      // Check success based on the status code
      final bool isSuccess =
          response.statusCode >= 200 && response.statusCode < 300;

      if (response.body.isNotEmpty) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (isSuccess) {
          return true; // Success case
        }
      }

      return false; // Failure case
    } catch (e) {
      print('Error during email verification: $e');
      return false; // Explicit failure in case of an exception
    }
  }

  static Future<AuthResult> resetPassword(String token, String newPassword,
      {String lang = 'ar'}) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/auth/reset-password?token=$token'),
        headers: _headers(),
        body: jsonEncode({
          'password': newPassword,
        }),
      );

      if (response.body.isNotEmpty) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final String message = responseData['message'] ?? 'Unknown error';
        return AuthResult(response.statusCode == 204, message);
      }

      return AuthResult(response.statusCode == 204,
          'Password reset ${response.statusCode == 204 ? 'successful' : 'failed'}');
    } catch (e) {
      print('Password reset error: $e');
      return AuthResult(false, e.toString());
    }
  }

  static Future<bool> deleteAccount({String lang = 'ar'}) async {
    final String? token = await StorageService.getToken('accessToken');

    if (token == null) {
      print('No access token found, user not authenticated.');
      return false; // If no token is found, consider the user as unauthenticated
    }

    try {
      final response = await _client.delete(
        Uri.parse(
            '$baseUrl/student/me?lng=${getCurrentLocale()}'), // Use current locale
        headers: _headers(token), // Send headers with Authorization token
      );

      // Check if the deletion was successful
      if (response.statusCode >= 200 && response.statusCode < 300) {
        // Optionally clear tokens after user deletion
        await Future.wait([
          StorageService.deleteToken("accessToken"),
          StorageService.deleteToken("refreshToken"),
        ]);
        return true; // Successfully deleted account
      } else {
        print('Account deletion failed: ${response.body}');
        return false; // Deletion failed
      }
    } catch (e) {
      print('Error during account deletion: $e');
      return false; // Error occurred, deletion not successful
    }
  }
}
