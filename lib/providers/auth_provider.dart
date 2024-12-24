import 'dart:async';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/student.dart';

class AuthProvider with ChangeNotifier {
  Student? _student;
  bool _isAuthenticated = false;
  bool _isLoading = true;
  bool _focused = true;

  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  Student? get student => _student;

  Future<void> handleWindowFocus() async {
    if (!_focused) {
      _focused = true;
      await refreshProfile();
    }
  }

  Future<void> handleWindowBlur() async {
    _focused = false;
  }

  Future<void> refreshProfile() async {
    try {
      final studentData = await AuthService.verifyToken();
      if (studentData != null) {
        _student = Student.fromJson(studentData);
        notifyListeners();
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

      final studentData = await AuthService.verifyToken();
      if (studentData != null) {
        print('Token verified, loading student data');
        _student = Student.fromJson(studentData);
        _isAuthenticated = true;
      } else {
        print('Token invalid, logging out');
        await logout();
      }
    } catch (e) {
      print('Auth initialization error: $e');
      await logout();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<AuthResult> login(String email, String password) async {
    try {
      final result = await AuthService.login(email, password);
      if (result.success) {
        await initAuth();
      }
      return result;
    } catch (e) {
      return AuthResult(false, e.toString());
    }
  }

  Future<void> logout() async {
    try {
      await AuthService.logout();
      _student = null;
      _isAuthenticated = false;
    } catch (e) {
      print('Logout error: $e');
    } finally {
      notifyListeners();
    }
  }
}
