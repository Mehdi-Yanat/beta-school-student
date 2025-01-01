import 'package:flutter/material.dart';
import 'package:online_course/theme/color.dart';
import 'package:online_course/utils/helper.dart';

class ChapterCard extends StatelessWidget {
  final Map<String, dynamic> chapter; // Contains chapter information
  final VoidCallback? onTap;

  const ChapterCard({
    Key? key,
    required this.chapter,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.only(bottom: 16), // Bottom margin between cards
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 0,
                spreadRadius: 2,
              ),
            ],
            borderRadius:
                BorderRadius.circular(16), // Rounded corners for the card
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Chapter Thumbnail with updated design
              Container(
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16), // Same as card border radius
                  ),
                  color: AppColor.textBoxColor, // Fallback background color
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top:
                        Radius.circular(16), // Apply rounded corners to the top
                  ),
                  child: Stack(
                    children: [
                      // Display thumbnail or fallback
                      Container(
                        width: double.infinity,
                        child: chapter['thumbnail'] != null
                            ? Image.network(
                                chapter['thumbnail'], // Chapter thumbnail
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, progress) =>
                                    progress == null
                                        ? child
                                        : Container(
                                            color: AppColor.textBoxColor,
                                            child: Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          ),
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                  color: AppColor.textBoxColor,
                                  child: Icon(
                                    Icons.image_not_supported,
                                    size: 48,
                                    color: Colors.grey,
                                  ),
                                ),
                              )
                            : Container(
                                color: AppColor.textBoxColor,
                                child: Icon(
                                  Icons.image_not_supported,
                                  size: 48, // Adjust size for better visibility
                                  color: Colors.grey,
                                ),
                              ),
                      ),
                      // Gradient Overlay
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                Colors.black
                                    .withValues(alpha: 0.5), // Gradient effect
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ),
                      // Duration Badge
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                color: Colors.white,
                                size: 14,
                              ),
                              SizedBox(width: 4),
                              Text(
                                Helpers.formatDuration(
                                    context, chapter['duration']),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Chapter Info
              Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      chapter['title'] ?? 'Untitled Chapter',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColor.darker,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),

                    // Description
                    if (chapter['description'] != null)
                      Text(
                        chapter['description'] ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColor.textColor.withValues(alpha: 0.8),
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    SizedBox(height: 8),

                    // Rating and Views
                    Row(
                      children: [
                        // Rating (Stars)
                        Icon(Icons.star,
                            color: Colors.amber, size: 18), // Rating icon
                        SizedBox(width: 4),
                        Text(
                          chapter['rating'] != null
                              ? chapter['rating'].toString()
                              : 'N/A',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColor.darker,
                          ),
                        ),
                        SizedBox(width: 12),

                        // Views
                        Icon(Icons.visibility,
                            color: AppColor.darker, size: 18), // Views icon
                        SizedBox(width: 4),
                        Text(
                          '${chapter['views'] ?? 0} views',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColor.mainColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
