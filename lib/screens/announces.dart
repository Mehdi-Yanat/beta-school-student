import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:online_course/models/announcements.dart';
import 'package:online_course/screens/teacher/teacher_announces.dart';
import 'package:online_course/services/student_service.dart';
import 'package:online_course/theme/color.dart';
import 'package:online_course/utils/helper.dart';
import 'package:online_course/widgets/announces_item.dart';

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
    return Scaffold(
      backgroundColor: AppColor.appBgColor,
      body: RefreshIndicator(
        onRefresh: _fetchAnnouncements,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              _buildHeader(context),
              if (_isLoading)
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (_announcements.isEmpty)
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(
                      AppLocalizations.of(context)!.no_announcements,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColor.darker,
                      ),
                    ),
                  ),
                )
              else
                // Update ListView.builder section:
                ListView.builder(
                  padding: EdgeInsets.only(top: 10),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _announcements.length,
                  itemBuilder: (context, index) {
                    final announcement = _announcements[index];
                    return AnnouncesItem(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TeacherAnnouncesPage(
                                  teacherId: announcement.teacher.id))),
                      {
                        'name': announcement.teacher.fullName,
                        'image': announcement.teacher.profilePic?.url,
                        'message': announcement.message,
                        'createdAt': announcement.createdAt,
                        'timeAgo': Helpers.getTimeAgo(
                            announcement.createdAt ?? DateTime.now(),
                            currentLocale),
                      },
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 60, 0, 5),
      child: Column(
        children: [
          Text(
            AppLocalizations.of(context)!.announces_title,
            style: TextStyle(
              color: AppColor.mainColor,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 15),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
