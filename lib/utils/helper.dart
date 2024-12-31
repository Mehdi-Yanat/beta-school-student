// Helper method for formatting duration from seconds to human-readable format

import 'package:online_course/models/mycourses.dart';

class Helpers {
  static String formatDuration(int seconds) {
    if (seconds < 0) {
      return '0m 0s'; // Handle negative values
    }

    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes}m ${remainingSeconds}s';
  }

  static String getTotalWatchTimeFormatted(List<MyCourse> courses) {
    int totalWatchTimeInSeconds = 0;

    for (var course in courses) {
      totalWatchTimeInSeconds += course.course.totalWatchTime;
    }

    if (totalWatchTimeInSeconds >= 3600) {
      // If total time is greater than or equal to 1 hour
      double totalWatchTimeInHours = totalWatchTimeInSeconds / 3600;
      return "${totalWatchTimeInHours.toStringAsFixed(2)}";
    } else {
      // If total time is less than 1 hour, display in minutes
      int totalWatchTimeInMinutes = (totalWatchTimeInSeconds / 60).toInt();
      return "$totalWatchTimeInMinutes";
    }
  }
}
