import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import localization
import 'package:online_course/providers/auth_provider.dart';
import 'package:online_course/providers/course_provider.dart';
import 'package:online_course/screens/course_detail.dart';
import 'package:online_course/theme/color.dart';
import 'package:online_course/utils/data.dart';
import 'package:online_course/widgets/category_box.dart';
import 'package:online_course/widgets/feature_item.dart';
import 'package:online_course/widgets/notification_box.dart';
import 'package:online_course/widgets/recommend_item.dart';
import 'package:provider/provider.dart';

import '../widgets/sliver_app_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CourseProvider>().fetchCourses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations =
        AppLocalizations.of(context); // Localizations instance
    return Scaffold(
      backgroundColor: AppColor.appBgColor,
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            pinned: true,
            snap: true,
            floating: true,
            toolbarHeight: 70,
            title: _buildAppBar(localizations),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _buildBody(localizations),
              childCount: 1,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAppBar(localizations) {
    return Consumer<AuthProvider>(builder: (context, authProvider, widget) {
      final isArabic = Localizations.localeOf(context).languageCode == 'ar';
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${isArabic ? authProvider.student!.firstNameAr : authProvider.student!.firstName} ${isArabic ? authProvider.student!.lastNameAr : authProvider.student!.lastName}", // Localized "Hello" text
                  style: TextStyle(
                    color: AppColor.labelColor,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  localizations.greeting, // Localized greeting
                  style: TextStyle(
                    color: AppColor.mainColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          NotificationBox(
            notifiedNumber: 1,
          )
        ],
      );
    });
  }

  Widget _buildBody(localizations) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCategories(localizations),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
            child: Text(
              localizations.featured, // Localized "Featured" title
              style: TextStyle(
                color: AppColor.mainColor,
                fontWeight: FontWeight.w600,
                fontSize: 24,
              ),
            ),
          ),
          _buildCoursesAccepted(),
          const SizedBox(height: 1),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  localizations.recommended, // Localized "Recommended" title
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: AppColor.mainColor,
                  ),
                ),
                Text(
                  localizations.see_all, // Localized "See all" text
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColor.darker,
                  ),
                ),
              ],
            ),
          ),
          _buildRecommended(),
        ],
      ),
    );
  }

  Widget _buildCategories(AppLocalizations localizations) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(15, 10, 0, 10),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          categories.length,
          (index) => Padding(
            padding: const EdgeInsets.only(right: 15),
            child: CategoryBox(
              selectedColor: AppColor.mainColor,
              data: categories[index],
              onTap: null,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCoursesAccepted() {
    return Consumer<CourseProvider>(
      builder: (context, courseProvider, child) {
        if (courseProvider.isLoading) {
          return Center(child: CircularProgressIndicator());
        }
  
        return CarouselSlider(
          options: CarouselOptions(
            height: 300,
            enlargeCenterPage: true,
            disableCenter: true,
            viewportFraction: .75,
          ),
          items: courseProvider.courses.map((course) {
            // Calculate total duration safely
            final totalDuration = course.chapters.fold<int>(
              0,
              (sum, chapter) => sum + (chapter.duration ?? 0)
            );
            
            // Calculate final price with discount
            final finalPrice = course.discount != null 
                ? course.price - course.discount!
                : course.price;
  
            return FeatureItem(
              data: {
                "image": course.icon?.url ?? "assets/images/default_course.png",
                "name": course.title,
                "price": "$finalPrice DA",
                "session": "${course.chapters.length} Sessions",
                "duration": "$totalDuration min",
                "review": course.teacher.yearsOfExperience.toString(),
              },
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CourseDetailScreen(courseId: course.id),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildRecommended() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(15, 5, 0, 5),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          recommends.length,
          (index) => Padding(
            padding: const EdgeInsets.only(right: 10),
            child: RecommendItem(
              data: recommends[index],
            ),
          ),
        ),
      ),
    );
  }
}
