import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:online_course/models/announcements.dart';
import 'package:online_course/screens/teacher/teacher_announces.dart';
import 'package:online_course/services/student_service.dart';
import 'package:online_course/theme/color.dart';
import 'package:online_course/utils/helper.dart';
import 'package:online_course/widgets/announces_item.dart';

import '../widgets/appbar.dart';

class AnnouncesPage extends StatefulWidget {
  const AnnouncesPage({Key? key}) : super(key: key);

  @override
  _AnnouncesPageState createState() => _AnnouncesPageState();
}

class _AnnouncesPageState extends State<AnnouncesPage> {
  List<Announcement> _announcements = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchAnnouncements();
  }

  Future<void> _fetchAnnouncements() async {
    if (!mounted) return;

    setState(() => _isLoading = true);

    try {
      final response = await StudentService.getAnnouncementsList();
      if (!mounted) return;

      setState(() {
        _announcements = response;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching announcements: $e');
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentLocale = Localizations.localeOf(context).languageCode;
    return RefreshIndicator(
      onRefresh: _fetchAnnouncements,
      child: Scaffold(
        appBar: CustomAppBar(
          title: AppLocalizations.of(context)!.announces_title,
        ),
        backgroundColor: AppColor.appBgColor,
        body: _isLoading
            ? Center( // Show loading indicator if fetching data
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: CircularProgressIndicator(),
          ),
        )
            : _announcements.isEmpty
            ? Center( // Show no announcements message if the list is empty
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              AppLocalizations.of(context)!.no_announcements,
              style: TextStyle(
                fontSize: 16,
                color: AppColor.darker,
              ),
            ),
          ),
        )
            : ListView.builder(
          padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
          itemCount: _announcements.length,
          itemBuilder: (context, index) {
            final announcement = _announcements[index];
            // Render each announcement in the list
            return AnnouncesItem(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TeacherAnnouncesPage(
                      teacherId: announcement.teacher.id),
                ),
              ),
              {
                'name': Localizations.localeOf(context).languageCode == 'ar' ? announcement.teacher.fullNameAr : announcement.teacher.fullName,
                'image': announcement.teacher.profilePic?.url ??
                    'assets/images/profile.png',
                'message': announcement.message,
                'createdAt': announcement.createdAt,
                'timeAgo': Helpers.getTimeAgo(
                  announcement.createdAt ?? DateTime.now(),
                  currentLocale,
                ),
              },
            );
          },
        ),
      ),
    );
  }


  @override
  void dispose() {
    super.dispose();
  }
}
