import 'package:http_interceptor/http_interceptor.dart';
import 'package:online_course/main.dart';
import 'package:online_course/models/transaction.dart';
import 'package:online_course/utils/auth_interceptor.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

import '../models/mycourses.dart';

class StudentService {
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

  // Get student self-transactions
  static Future<List<Transaction>> getStudentTransactions() async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/transactions/student?lng=${getCurrentLocale()}'),
        headers: _headers(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Parse JSON into Transaction objects
        if (data['transactions'] != null) {
          return (data['transactions'] as List)
              .map((json) => Transaction.fromJson(json))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('❌ Error getting student transactions: $e');
      return [];
    }
  }

// Get a specific transaction by ID
  static Future getTransactionByCheckoutId(String checkoutId) async {
    try {
      final response = await _client.get(
        Uri.parse(
            '$baseUrl/transactions/transaction/invoice/$checkoutId?lng=${getCurrentLocale()}'),
        headers: _headers(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Parse JSON into a Transaction object
        if (data != null) {
          return data['transaction'];
        }
      }
      return null;
    } catch (e) {
      print('❌ Error getting transaction by ID: $e');
      return null;
    }
  }

  static Future<List<MyCourse>> getStudentCourses() async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/student/mycourses?lng=${getCurrentLocale()}'),
        headers: _headers(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data['courses'] as List<dynamic>)
            .map((json) => MyCourse.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      print('❌ Error getting student courses: $e');
      return [];
    }
  }
}
