import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:online_course/providers/course_provider.dart';
import 'package:online_course/screens/course/course_detail.dart';
import 'package:online_course/theme/color.dart';
import 'package:online_course/widgets/course_image.dart';
import 'package:online_course/widgets/filter_modal.dart';
import 'package:provider/provider.dart';
import 'package:online_course/widgets/appbar.dart';

import '../utils/helper.dart';

class ExploreScreen extends StatefulWidget {
  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  String _selectedCategory = 'ALL';

  final List<String> subjectKeys = [
    'ALL',
    'MATHEMATICS',
    'SCIENCE',
    'PHYSICS',
    'HISTORY_GEOGRAPHY',
    'ISLAMIC_STUDIES',
    'ARABIC',
    'FRENCH',
    'ENGLISH',
    'OTHER'
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CourseProvider>().fetchCourses(
            refresh: true,
            context: context,
          );
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      final provider = context.read<CourseProvider>();
      if (!provider.isLoading && provider.hasMore) {
        provider.fetchCourses(context: context);
      }
    }
  }

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      builder: (context) => FilterModal(),
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBgColor,
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.explore_title,
      ),
      body: Column(
        children: [
          // Search Bar
          _buildSearchBar(),

          // Categories
          _buildCategories(),

          // Course Grid
          // Replace Expanded section with:
          // Replace Expanded section with:
          Expanded(
            child: Consumer<CourseProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading && provider.courses.isEmpty) {
                  return Center(child: CircularProgressIndicator());
                }

                if (provider.courses.isEmpty) {
                  return _buildEmptyState();
                }

                return ListView.builder(
                  controller: _scrollController,
                  itemCount:
                      provider.courses.length + (provider.hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == provider.courses.length) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    final course = provider.courses[index];
                    final firstChapter = course.chapters.isNotEmpty
                        ? course.chapters.first
                        : null;

                    final totalDuration = course.chapters.fold<int>(
                        0, (sum, chapter) => sum + (chapter.duration));

                    final formatedDuration = Helpers.formatTime(totalDuration);

                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CourseDetailScreen(courseId: course.id),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColor.cardColor,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    AppColor.shadowColor.withValues(alpha: 0.1),
                                blurRadius: 8,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(12)),
                                child: CourseImage(
                                  thumbnailUrl: firstChapter?.thumbnail?.url,
                                  iconUrl: course.icon?.url,
                                  width: double.infinity,
                                  height: 190,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      course.title,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColor.mainColor,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Text(
                                            course.price.toString() +
                                                " ${AppLocalizations.of(context)?.dzd}",
                                            style: TextStyle(
                                                color: AppColor.darker)),
                                        SizedBox(width: 12),
                                        Icon(Icons.play_circle_fill,
                                            color: AppColor.darker, size: 18),
                                        Text(
                                          AppLocalizations.of(context)!
                                              .course_lessons(
                                                  course.chapters.length),
                                          style:
                                              TextStyle(color: AppColor.darker),
                                        ),
                                        SizedBox(width: 12),
                                        Icon(Icons.schedule,
                                            color: AppColor.darker, size: 18),
                                        Text(
                                          "$formatedDuration ${AppLocalizations.of(context)!.hours}",
                                          style:
                                              TextStyle(color: AppColor.darker),
                                        ),
                                        /*
                                        Spacer(),
                                        Row(
                                          children: [
                                            Icon(Icons.star,
                                                color: AppColor.yellow,
                                                size: 18),
                                            Text("4.5",
                                                style: TextStyle(
                                                    color: AppColor.darker)),
                                          ],
                                        ),
                                        */
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: AppColor.cardColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: AppColor.shadowColor.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (value) {
            context.read<CourseProvider>().setFilters(
                searchQuery: value.isEmpty ? null : value, context: context);
          },
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)!.search_hint,
            prefixIcon: Icon(Icons.search, color: AppColor.inActiveColor),
            suffixIcon: IconButton(
              icon: Icon(Icons.filter_alt_outlined, color: AppColor.primary),
              onPressed: _showFilterModal,
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    );
  }

  Widget _buildCategories() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: subjectKeys.map((category) {
          return Padding(
            padding: EdgeInsets.only(right: 8),
            child: FilterChip(
              selected: _selectedCategory == category,
              onSelected: (selected) {
                setState(() => _selectedCategory = category);
                context.read<CourseProvider>().setFilters(
                    subject: category == 'ALL' ? null : category,
                    context: context);
              },
              label: Text(
                AppLocalizations.of(context)!.getCategoryName(category),
              ),
              backgroundColor: AppColor.cardColor,
              selectedColor: AppColor.primary,
              labelStyle: TextStyle(
                color: _selectedCategory == category
                    ? AppColor.glassTextColor
                    : AppColor.mainColor,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.school_outlined, size: 64, color: AppColor.mainColor),
          SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.no_courses_found,
            style: TextStyle(
              fontSize: 16,
              color: AppColor.mainColor,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

extension LocalizationsExtensions on AppLocalizations {
  String getCategoryName(String key) {
    switch (key) {
      case 'ALL':
        return categories_all;
      case 'MATHEMATICS':
        return categories_mathematics;
      case 'SCIENCE':
        return categories_science;
      case 'PHYSICS':
        return categories_physics;
      case 'HISTORY_GEOGRAPHY':
        return categories_history_geography;
      case 'ISLAMIC_STUDIES':
        return categories_islamic_studies;
      case 'ARABIC':
        return categories_arabic;
      case 'FRENCH':
        return categories_french;
      case 'ENGLISH':
        return categories_english;
      case 'OTHER':
        return categories_other;
      default:
        return '';
    }
  }
}
