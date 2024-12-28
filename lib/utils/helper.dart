// Helper method for formatting duration from seconds to human-readable format

class Helpers {
  static String formatDuration(int seconds) {
    if (seconds < 0) {
      return '0m 0s'; // Handle negative values
    }

    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes}m ${remainingSeconds}s';
  }
}
