import 'package:flutter/widgets.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:online_course/main.dart';
import 'package:online_course/models/announcements.dart';
import 'package:online_course/models/teacher_announcements.dart';
import 'package:online_course/models/transaction.dart';
import 'package:online_course/utils/auth_interceptor.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:online_course/widgets/snackbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import localization
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
      'Accept-Language': getCurrentLocale()
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
        if (data['transactions'] != null) {
          return (data['transactions'] as List)
              .where((json) => json != null)
              .map((json) {
                try {
                  return Transaction.fromJson(json);
                } catch (e) {
                  return null;
                }
              })
              .whereType<Transaction>()
              .toList();
        }
      }
      return [];
    } catch (e, stack) {
      print('❌ Error getting student transactions: $e');
      print('📍 Stack trace: $stack');
      return [];
    }
  }

  static Future<void> enrollByCash(BuildContext context,String courseId) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/course/${courseId}/enroll/cash'),
        headers: _headers(),
      );

      if (response.statusCode >= 200 && response.statusCode < 400) {
        final data = json.decode(response.body);
        if (data['message'] != null) {
          SnackBarHelper.showSuccessSnackBar(context, data['message']);
        }
      } else {
        SnackBarHelper.showErrorSnackBar(context, AppLocalizations.of(context)!.something_went_wrong);
      }
    } catch (e, stack) {
      print('❌ Error getting student transactions: $e');
      print('📍 Stack trace: $stack');
      throw e;
    }
  }

    static Future<Map<String, dynamic>> checkCashTransaction(String courseId) async {
        try {
            final response = await _client.get(
                Uri.parse('$baseUrl/transactions/check/${courseId}?lng=${getCurrentLocale()}'),
                headers: _headers(),
            );

            if (response.statusCode >= 200 && response.statusCode < 400) {
                final data = json.decode(response.body);
                if (data != null) {
                    return data as Map<String, dynamic>;
                }
                return <String, dynamic>{};
            }
        } catch (e, stack) {
            print('❌ Error getting student transactions: $e');
            print('📍 Stack trace: $stack');
            throw e;
        }

        return <String, dynamic>{};
    }

  static Future<void> cancelCashTransaction(BuildContext context,String transactionId) async {
    try {
      final response = await _client.delete(
        Uri.parse('$baseUrl/transactions/cancel/${transactionId}?lng=${getCurrentLocale()}'),
        headers: _headers(),
      );

      if (response.statusCode >= 200 && response.statusCode < 400) {
        final data = json.decode(response.body);
        if (data['status'] != null) {
          SnackBarHelper.showSuccessSnackBar(context, data['message']);
        }
      } else {
        SnackBarHelper.showErrorSnackBar(context, AppLocalizations.of(context)!.something_went_wrong);
      }
    } catch (e, stack) {
      print('❌ Error getting student transactions: $e');
      print('📍 Stack trace: $stack');
      throw e;
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
        final courses = data['courses'] as List<dynamic>?;

        if (courses == null) {
          return [];
        }

        return courses
            .where((json) => json != null)
            .map((json) {
              try {
                return MyCourse.fromJson(json);
              } catch (e) {
                print('❌ Error parsing course: $e');
                print('🔍 Problem data: $json');
                return null;
              }
            })
            .whereType<MyCourse>()
            .toList();
      }

      print('❌ Failed to get courses: ${response.statusCode}');
      return [];
    } catch (e, stack) {
      print('❌ Error getting student courses: $e');
      print('📍 Stack trace: $stack');
      return [];
    }
  }

  // Add debug logging in getAnnouncementsList:
  static Future<List<Announcement>> getAnnouncementsList() async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/announcement/me?lng=${getCurrentLocale()}'),
        headers: _headers(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final announcements =
            data.map((json) => Announcement.fromJson(json)).toList();

        print('✅ Parsed ${announcements.length} announcements');
        return announcements;
      }

      print('❌ Failed to get announcements: ${response.statusCode}');
      return [];
    } catch (e, stack) {
      print('❌ Error getting announcements: $e');
      print('📍 Stack trace: $stack');
      return [];
    }
  }

  static Future<List<TeacherAnnouncement>> getTeacherAnnouncementsList(
      teacherId) async {
    try {
      final response = await _client.get(
        Uri.parse(
            '$baseUrl/announcement/teacher/$teacherId?lng=${getCurrentLocale()}'),
        headers: _headers(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final announcements =
            TeacherAnnouncementResponse.fromJson(data).Teacherannouncements;
        print('✅ Parsed ${announcements.length} teacher announcements');
        return announcements;
      }

      print('❌ Failed to get announcements: ${response.statusCode}');
      return [];
    } catch (e, stack) {
      print('❌ Error getting announcements: $e');
      print('📍 Stack trace: $stack');
      return [];
    }
  }
}
