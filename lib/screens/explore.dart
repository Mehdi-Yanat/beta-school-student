import 'package:flutter/material.dart';
import 'package:online_course/theme/color.dart';

class ExploreScreen extends StatelessWidget {
  final List<Map<String, String>> categories = [
    {'name': 'All', 'icon': 'assets/icons/all.png'},
    {'name': 'Coding', 'icon': 'assets/icons/coding.png'},
    {'name': 'Education', 'icon': 'assets/icons/education.png'},
    {'name': 'Design', 'icon': 'assets/icons/design.png'},
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
    return Scaffold(
      backgroundColor: AppColor.appBgColor,
      appBar: AppBar(
        title: Text(
          "Explore",
          style: TextStyle(
            color: AppColor.mainColor,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        backgroundColor: AppColor.appBarColor,
        centerTitle: false,
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
                  hintText: "Search",
                  prefixIcon: Icon(Icons.search, color: AppColor.inActiveColor),
                  suffixIcon:
                      Icon(Icons.filter_alt_outlined, color: AppColor.primary),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),

          // Categories
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: categories
                  .map((category) => Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Chip(
                          label: Text(category['name']!),
                          backgroundColor: category['name'] == 'All'
                              ? AppColor.primary
                              : AppColor.cardColor,
                          labelStyle: TextStyle(
                            color: category['name'] == 'All'
                                ? AppColor.glassTextColor
                                : AppColor.mainColor,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: AppColor.labelColor.withOpacity(0.3),
                            ),
                          ),
                        ),
                      ))
                  .toList(),
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
                                  color: AppColor.textColor,
                                ),
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.attach_money,
                                      color: AppColor.labelColor, size: 18),
                                  Text(course['price'],
                                      style:
                                          TextStyle(color: AppColor.textColor)),
                                  SizedBox(width: 12),
                                  Icon(Icons.play_circle_fill,
                                      color: AppColor.labelColor, size: 18),
                                  Text(course['lessons'],
                                      style:
                                          TextStyle(color: AppColor.textColor)),
                                  SizedBox(width: 12),
                                  Icon(Icons.schedule,
                                      color: AppColor.labelColor, size: 18),
                                  Text(course['duration'],
                                      style:
                                          TextStyle(color: AppColor.textColor)),
                                  Spacer(),
                                  Row(
                                    children: [
                                      Icon(Icons.star,
                                          color: AppColor.yellow, size: 18),
                                      Text(course['rating'],
                                          style: TextStyle(
                                              color: AppColor.textColor)),
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
