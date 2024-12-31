import 'dart:async';
import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../services/auth_service.dart';
import '../models/student.dart';
import '../services/student_service.dart';

class AuthProvider with ChangeNotifier {
  Student? _student;
  bool _isAuthenticated = false;
  bool _isLoading = true;
  bool _focused = true;

  List<Transaction> _studentTransactions = []; // Use Transaction model

  bool get isAuthenticated => _isAuthenticated;

  bool get isLoading => _isLoading;

  Student? get student => _student;

  // Expose transactions
  List<Transaction> get studentTransactions => _studentTransactions;

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
        fetchStudentTransactions();
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

  // Fetch student transactions from the service
  Future<void> fetchStudentTransactions() async {
    if (_student != null) {
      try {
        print('Fetching student transactions...');
        // Use updated service to get parsed Transaction objects
        final transactions = await StudentService.getStudentTransactions();
        _studentTransactions = transactions;
        print('Transactions fetched successfully');
      } catch (e) {
        print('Error fetching transactions: $e');
        _studentTransactions = []; // Clear on error
      } finally {
        notifyListeners(); // Notify the UI
      }
    }
  }
}
