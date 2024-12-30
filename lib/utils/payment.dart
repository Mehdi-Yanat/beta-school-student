import 'package:flutter/material.dart';
import 'package:online_course/widgets/snackbar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:online_course/services/course_service.dart';

class PaymentHandler {
  // This method handles enrollment and payment redirection
  static Future<void> enrollAndRedirect(
      BuildContext context, String courseId) async {
    try {
      // Make API call to enroll the course and get the payment URL
      final paymentUrl = await CourseService.enrollCourse(courseId);

      if (paymentUrl != null) {
        // 🎉 Payment URL is returned - Try redirecting to the payment page
        if (await canLaunchUrl(Uri.parse(paymentUrl))) {
          await launchUrl(
            Uri.parse(paymentUrl),
          );
        } else {
          // ❌ Unable to launch the payment URL

          throw Exception(
              'canlanch: ${await canLaunchUrl(Uri.parse(paymentUrl))}   Cannot launch payment URL: $paymentUrl  ');
        }
      } else {
        // ❌ Enrollment failed - Payment URL is null
        throw Exception('Enrollment failed, payment URL not provided.');
      }
    } catch (e) {
      // Show error message in a SnackBar
      SnackBarHelper.showErrorSnackBar(
        context,
        e.toString(),
      );

      // Debugging: Log the error details for developers
      debugPrint(
          '❌ Exception during course enrollment and payment redirection: $e');
    }
  }

// Helper method to redirect to a payment URL
}
