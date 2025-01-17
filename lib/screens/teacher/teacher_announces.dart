import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:online_course/models/teacher_announcements.dart';
import 'package:online_course/services/student_service.dart';
import 'package:online_course/theme/color.dart';
import 'package:online_course/utils/helper.dart';
import 'package:online_course/widgets/announces_item.dart';
import 'package:online_course/widgets/custom_image.dart';

import '../../widgets/appbar.dart';

class TeacherAnnouncesPage extends StatefulWidget {
  final teacherId;
  const TeacherAnnouncesPage({Key? key, required this.teacherId})
      : super(key: key);

  @override
  _TeacherAnnouncesPageState createState() => _TeacherAnnouncesPageState();
}

class _TeacherAnnouncesPageState extends State<TeacherAnnouncesPage> {
  List<TeacherAnnouncement> _announcements = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchAnnouncements();
  }

  @override
  void didUpdateWidget(TeacherAnnouncesPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Check if teacherId changed
    if (oldWidget.teacherId != widget.teacherId) {
      _fetchAnnouncements(); // Fetch new data if teacherId changed
    }
  }

  Future<void> _fetchAnnouncements() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      final response =
          await StudentService.getTeacherAnnouncementsList(widget.teacherId);
      if (!mounted) return;

      setState(() {
        _announcements = response;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching announcements: $e');
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentLocale = Localizations.localeOf(context).languageCode;
    return Scaffold(
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.all_teacher_announces_title,
      ),
      backgroundColor: AppColor.appBgColor,
      body: RefreshIndicator(
        onRefresh: _fetchAnnouncements,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
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
                      "${AppLocalizations.of(context)!.no_announcements}",
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
                      onTap: () =>
                          _showAnnouncementDetails(announcement, context),
                      {
                        'name':
                            Localizations.localeOf(context).languageCode == 'ar'
                                ? announcement.teacher.fullNameAr
                                : announcement.teacher.fullName,
                        'image': announcement.teacher.user.profilePic?.url ??
                            'assets/images/profile.png',
                        'message': announcement.message,
                        'createdAt': announcement.createdAt,
                        'timeAgo': Helpers.getTimeAgo(
                            announcement.createdAt, currentLocale),
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
            _announcements.isNotEmpty
                ? "${AppLocalizations.of(context)!.announces_title} ${_announcements[0].teacher.fullName}"
                : AppLocalizations.of(context)!.announces_title,
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

void _showAnnouncementDetails(
    TeacherAnnouncement announcement, BuildContext context) {
  final isNetwork =
      announcement.teacher.user.profilePic?.url.startsWith('http') ?? false;

  showDialog(
    context: context,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                CustomImage(
                  announcement.teacher.user.profilePic?.url ??
                      '/assets/images/profile.png',
                  width: 60,
                  height: 60,
                  radius: 30,
                  isNetwork: isNetwork,
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        announcement.teacher.fullName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColor.textColor,
                        ),
                      ),
                      Text(
                        Helpers.getTimeAgo(
                            announcement.createdAt ?? DateTime.now(),
                            Localizations.localeOf(context).languageCode),
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColor.labelColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Divider(height: 20),
            SelectableText.rich(
              Helpers.buildTextSpanWithLinks(announcement.message),
              style: TextStyle(
                fontSize: 16,
                color: AppColor.textColor,
              ),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context)!.close_button),
            ),
          ],
        ),
      ),
    ),
  );
}
