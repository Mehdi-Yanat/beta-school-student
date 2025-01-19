import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:online_course/providers/course_provider.dart';
import 'package:online_course/screens/course/course_detail.dart';
import 'package:online_course/theme/color.dart';
import 'package:online_course/widgets/appbar.dart';
import 'package:online_course/widgets/course_image.dart';
import 'package:online_course/widgets/filter_modal.dart';
import 'package:provider/provider.dart';

import '../utils/helper.dart';
import '../utils/translation.dart';

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
      _refreshData();
    });
  }

  Future<void> _refreshData() async {
    await context.read<CourseProvider>().fetchCourses(
      refresh: true,
      context: context,
      filters: {
        'subject': _selectedCategory == 'ALL' ? null : _selectedCategory,
        'searchQuery':
            _searchController.text.isEmpty ? null : _searchController.text,
      },
    );
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      final provider = context.read<CourseProvider>();
      if (!provider.isLoading && provider.hasMore) {
        provider.fetchCourses(
          context: context,
          filters: {
            'subject': _selectedCategory == 'ALL' ? null : _selectedCategory,
            'searchQuery':
                _searchController.text.isEmpty ? null : _searchController.text,
          },
        );
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
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: Scaffold(
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

                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.75,
                      ),
                      shrinkWrap: true,
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

                        final formatedDuration =
                            Helpers.formatTimeHours(totalDuration);

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
                                horizontal: 2, vertical: 8),
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColor.cardColor,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColor.shadowColor
                                        .withValues(alpha: 0.1),
                                    blurRadius: 8,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min, // Add this line
                                children: [
                                  Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(12)),
                                        child: CourseImage(
                                          thumbnailUrl:
                                              firstChapter?.thumbnail?.url,
                                          iconUrl: course.icon?.url,
                                          width: double.maxFinite,
                                          height: 120,
                                        ),
                                      ),
                                      if (course.discount != null &&
                                          course.discount! > 0)
                                        Positioned(
                                          top: 80,
                                          right: 0,
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 6),
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withValues(alpha: 0.2),
                                                  blurRadius: 4,
                                                  offset: Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.local_offer,
                                                  color: Colors.white,
                                                  size: 16,
                                                ),
                                                SizedBox(width: 4),
                                                Text(
                                                  "-${course.discount}%",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      Positioned(
                                        child: Container(
                                          padding: const EdgeInsets.all(12.0),
                                          decoration: BoxDecoration(
                                              color: AppColor.brandMain
                                                  .withValues(alpha: 1),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(12))),
                                          child: Text(
                                            TranslationHelper
                                                .getTranslatedSubject(
                                                    context, course.subject),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 15),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          course.title,
                                          maxLines: 1,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: AppColor.mainColor,
                                          ),
                                        ),
                                        Text(
                                          course.description,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: AppColor.mainColor
                                                .withValues(alpha: 0.5),
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 7),
                                        Row(
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                if (course.discount != null &&
                                                    course.discount! > 0) ...[
                                                  Text(
                                                    "${course.price} ${AppLocalizations.of(context)?.dzd}",
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                      fontSize: 8,
                                                    ),
                                                  ),
                                                ],
                                                Text(
                                                  "${(course.price - (course.price * (course.discount ?? 0) / 100)).toStringAsFixed(2)} ${AppLocalizations.of(context)?.dzd}",
                                                  style: TextStyle(
                                                      color: course.discount !=
                                                                  null &&
                                                              course.discount! >
                                                                  0
                                                          ? Colors.red
                                                          : AppColor.darker,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      fontSize: 12),
                                                ),
                                              ],
                                            ),
                                            Spacer(),
                                            Icon(Icons.video_collection_rounded,
                                                color: AppColor.darker,
                                                size: 18),
                                            Text(
                                              " " +
                                                  AppLocalizations.of(context)!
                                                      .course_lessons(course
                                                          .chapters.length),
                                              style: TextStyle(
                                                  color: AppColor.darker),
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
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            if (course.rating != null &&
                                                course.rating! * 5 > 2.3)
                                              Icon(Icons.star_rounded,
                                                  color: AppColor.yellow,
                                                  size: 18),
                                            if (course.rating != null &&
                                                course.rating! * 5 > 2.3)
                                            Text((course.rating! * 5).toString(),
                                                style: TextStyle(
                                                    color: AppColor.darker)),
                                            Spacer(),
                                            Icon(Icons.people_alt_rounded,
                                                color: AppColor.darker,
                                                size: 18),
                                            Text(
                                                course.currentEnrollment
                                                    .toString(),
                                                style: TextStyle(
                                                    color: AppColor.darker)),
                                            Spacer(),
                                            Icon(Icons.schedule,
                                                color: AppColor.darker,
                                                size: 18),
                                            Text(
                                              Helpers.formatHoursAndMinutes(
                                                  context,
                                                  course.totalWatchTime ?? 0),
                                              style: TextStyle(
                                                  color: AppColor.darker),
                                            ),
                                          ],
                                        ),
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
          )),
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
          Image.asset(
            "assets/images/empty-folder.png",
            width: 200,
          ),
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
