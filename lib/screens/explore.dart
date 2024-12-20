import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import localization
import 'package:online_course/theme/color.dart';

import '../widgets/appbar.dart';

class ExploreScreen extends StatelessWidget {
  final List<String> categoryKeys = [
    'categories_all',
    'categories_mathematics',
    'categories_science',
    'categories_physics',
    'categories_history_geography',
    'categories_islamic_studies',
    'categories_arabic',
    'categories_french',
    'categories_english',
    'categories_other',
  ];

  final List<Map<String, dynamic>> courses = [
    {
      'title': 'UI/UX Design',
      'price': '\$110.00',
      'lessons': '6 lessons',
      'duration': '10 hours',
      'rating': '4.5',
      'image':
          'https://images.unsplash.com/photo-1596548438137-d51ea5c83ca5?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60',
    },
    {
      'title': 'Flutter Development',
      'price': '\$120.00',
      'lessons': '8 lessons',
      'duration': '12 hours',
      'rating': '4.7',
      'image':
          'https://images.unsplash.com/photo-1522071820081-009f0129c71c?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColor.appBgColor,
      appBar: CustomAppBar(
        title: localizations!.explore_title, // Localized title
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: AppColor.cardColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.shadowColor.withOpacity(0.1),
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: localizations.search_hint,
                  // Localized search hint
                  prefixIcon: Icon(Icons.search, color: AppColor.inActiveColor),
                  suffixIcon: Icon(
                    Icons.filter_alt_outlined,
                    color: AppColor.primary,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),

          // Categories
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: categoryKeys
                    .map((key) => Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Chip(
                            label: Text(localizations.getCategoryName(
                                key)), // Fetch translated category name
                            backgroundColor: key == 'categories_all'
                                ? AppColor.primary
                                : AppColor.cardColor,
                            labelStyle: TextStyle(
                              color: key == 'categories_all'
                                  ? AppColor.glassTextColor
                                  : AppColor.mainColor,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ),

          SizedBox(height: 10),

          // Course List
          Expanded(
            child: ListView.builder(
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final course = courses[index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColor.cardColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.shadowColor.withOpacity(0.1),
                          blurRadius: 8,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Course Image
                        ClipRRect(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(12)),
                          child: Image.network(
                            course['image'],
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),

                        // Course Info
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                course['title'],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.mainColor,
                                ),
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.attach_money,
                                      color: AppColor.darker, size: 18),
                                  Text(course['price'],
                                      style: TextStyle(color: AppColor.darker)),
                                  SizedBox(width: 12),
                                  Icon(Icons.play_circle_fill,
                                      color: AppColor.darker, size: 18),
                                  Text(
                                    localizations.course_lessons(int.parse(
                                        course['lessons'].split(
                                            ' ')[0])), // Localized lessons
                                    style: TextStyle(color: AppColor.darker),
                                  ),
                                  SizedBox(width: 12),
                                  Icon(Icons.schedule,
                                      color: AppColor.darker, size: 18),
                                  Text(
                                    localizations.course_duration(
                                        course['duration'].split(
                                            " ")[0]), // Localized duration
                                    style: TextStyle(color: AppColor.darker),
                                  ),
                                  Spacer(),
                                  Row(
                                    children: [
                                      Icon(Icons.star,
                                          color: AppColor.yellow, size: 18),
                                      Text(course['rating'],
                                          style: TextStyle(
                                              color: AppColor.darker)),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

extension LocalizationsExtensions on AppLocalizations {
  String getCategoryName(String key) {
    switch (key) {
      case 'categories_all':
        return categories_all;
      case 'categories_mathematics':
        return categories_mathematics;
      case 'categories_science':
        return categories_science;
      case 'categories_physics':
        return categories_physics;
      case 'categories_history_geography':
        return categories_history_geography;
      case 'categories_islamic_studies':
        return categories_islamic_studies;
      case 'categories_arabic':
        return categories_arabic;
      case 'categories_french':
        return categories_french;
      case 'categories_english':
        return categories_english;
      case 'categories_other':
        return categories_other;
      default:
        return '';
    }
  }
}
