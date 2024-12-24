import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:online_course/utils/storage.dart';
import '../services/auth_service.dart';
import '../models/student.dart';

class AuthProvider with ChangeNotifier {
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  Student? _student;
  bool _isAuthenticated = false;
  bool _isLoading = true;

  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  Student? get student => _student;

  Future<void> refreshProfile() async {
    try {
      final token = await StorageService.getToken('accessToken');
      if (token != null) {
        final studentData = await AuthService.verifyToken(token);
        if (studentData != null) {
          _student = Student.fromJson(studentData);
          notifyListeners();
        }
      }
    } catch (e) {
      print('Error refreshing profile: $e');
    }
  }

  Future<void> initAuth() async {
    try {
      print('Initializing auth state...');
      _isLoading = true;
      notifyListeners();

      final token = await _storage.read(key: 'accessToken');
      print('Retrieved token: ${token?.substring(0, 10)}...');

      if (token?.isNotEmpty ?? false) {
        print('Verifying token...');
        final studentData = await AuthService.verifyToken(token!);
        print(studentData.toString());

        if (studentData != null) {
          print('Token verified, loading student data');
          _student = Student.fromJson(studentData);
          _isAuthenticated = true;
        } else {
          print('Token invalid, logging out');
          await logout();
        }
      } else {
        print('No token found');
        _isAuthenticated = false;
      }
    } catch (e) {
      print('Auth initialization error: $e');
      await logout();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<AuthResult> login(String email, String password, String lang) async {
    try {
      final result = await AuthService.login(email, password, lang: lang);
      if (result.success) {
        await initAuth(); // Re-initialize auth state
      }
      return result;
    } catch (e) {
      return AuthResult(false, e.toString());
    }
  }

  Future<void> logout() async {
    try {
      // Call the logout service to invalidate the session on the backend
      final result = await AuthService.logout();
      if (result) {
        print('Backend logout successful');
      } else {
        print('Backend logout failed');
      }

      // Clear tokens locally regardless of backend result
      await _storage.delete(key: 'accessToken');
      await _storage.delete(key: 'refreshToken');
      _student = null;
      _isAuthenticated = false;
    } catch (e) {
      print('Logout error: $e');
    }
    notifyListeners();
  }
}
