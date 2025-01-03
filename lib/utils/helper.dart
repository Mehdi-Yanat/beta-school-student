// Helper method for formatting duration from seconds to human-readable format

import 'package:flutter/cupertino.dart';
import 'package:online_course/models/mycourses.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import localization
import 'package:timeago/timeago.dart' as timeago;

class Helpers {
  static void initTimeAgoLocales() {
    timeago.setLocaleMessages('fr', timeago.FrMessages());
    timeago.setLocaleMessages('ar', timeago.ArMessages());
  }

  static String formatDuration(BuildContext context, int seconds) {
    if (seconds < 0) {
      return '0 ${AppLocalizations.of(context)!.minutes} 0 ${AppLocalizations.of(context)!.second}'; // Handle negative values
    }

    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;

    return '${minutes} ${AppLocalizations.of(context)!.minutes} ${remainingSeconds} ${AppLocalizations.of(context)!.second}';
  }

  static String getTimeAgo(DateTime dateTime, String locale) {
    try {
      return timeago.format(
        dateTime,
        locale: locale,
        allowFromNow: true,
      );
    } catch (e) {
      // Fallback to English if locale isn't initialized
      print('Error formatting time with locale $locale: $e');
      return timeago.format(
        dateTime,
        locale: 'en',
        allowFromNow: true,
      );
    }
  }

  static String formatTime(int seconds) {
    int minutes = seconds ~/ 60;

    int hours = 0;
    if (minutes >= 60) {
      hours = minutes ~/ 60;
      minutes %= 60;
    }

    // Format the result as a string
    return '$hours';
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
