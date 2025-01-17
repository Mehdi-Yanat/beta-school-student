import 'package:flutter/material.dart';

// You can replace these colors with your theme or custom color values.
class AppColors {
  static const Color secondaryContainerGray = Color(0xFFB0BEC5);
  static const Color ratingPrimaryColor =
      Color(0xFFFFD700); // Gold color for rating stars
}

class StarRating extends StatelessWidget {
  final int starCount;
  final double rating;
  final Color? color;
  final double? size;
  const StarRating(
      {super.key,
      this.starCount = 5, // Default to 5 stars
      this.rating = 0.0, // Default rating is 0
      this.color, // Optional: custom color for stars
      this.size});
  // Method to build each individual star based on the rating and index
  Widget buildStar(final BuildContext context, final int index) {
    Icon icon;
    // If the index is greater than or equal to the rating, we show an empty star
    if (index >= rating) {
      icon = Icon(
        Icons.star_border_rounded, // Empty star
        size: size ?? 16,
        color: AppColors.secondaryContainerGray, // Light gray for empty stars
      );
    }
    // If the index is between the rating minus 1 and the rating, we show a half star
    else if (index > rating - 1 && index < rating) {
      icon = Icon(
        Icons.star_half_rounded, // Half star
        size: size ?? 16,
        color: color ??
            AppColors
                .ratingPrimaryColor, // Default to gold color or custom color
      );
    }
    // Otherwise, we show a full star
    else {
      icon = Icon(
        Icons.star_rounded, // Full star
        size: size ?? 16,
        color: color ??
            AppColors
                .ratingPrimaryColor, // Default to gold color or custom color
      );
    }
    return icon;
  }

  @override
  Widget build(final BuildContext context) {
    // Creating a row of stars based on the starCount
    return Row(
      children: List.generate(
        starCount, // Generate a row with 'starCount' stars
        (final index) => buildStar(context, index),
      ),
    );
  }
}
