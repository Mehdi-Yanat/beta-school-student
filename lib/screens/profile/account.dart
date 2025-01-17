import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import localization
import 'package:online_course/models/mycourses.dart';
import 'package:online_course/models/student.dart';
import 'package:online_course/providers/auth_provider.dart';
import 'package:online_course/screens/profile/payments.dart';
import 'package:online_course/screens/profile/privacy.dart';
import 'package:online_course/screens/profile/settings.dart';
import 'package:online_course/theme/color.dart';
import 'package:online_course/utils/helper.dart';
import 'package:online_course/widgets/custom_image.dart';
import 'package:online_course/widgets/dialog.dart';
import 'package:online_course/widgets/setting_box.dart';
import 'package:online_course/widgets/setting_item.dart';
import 'package:provider/provider.dart';
import '../../providers/course_provider.dart';
import '../../widgets/appbar.dart';
import 'licenses.dart';
import 'contact/ContactInfoPage.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        final student = authProvider.student;

        return Consumer<CourseProvider>(
          builder: (context, courseProvider, _) {
            final myCourses = courseProvider.myCourses;

            return Scaffold(
              appBar: CustomAppBar(
                title: AppLocalizations.of(context)!.account_title,
              ),
              body: CustomScrollView(
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: _buildBody(context, student, myCourses),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBody(context, Student? student, List<MyCourse> myCourses) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Column(
        children: [
          _buildProfile(context, student),
          const SizedBox(
            height: 20,
          ),
          _buildRecord(context, student, myCourses),
          const SizedBox(
            height: 20,
          ),
          _buildSection1(context, student),
          const SizedBox(
            height: 20,
          ),
          _buildSection2(context, student),
          const SizedBox(
            height: 20,
          ),
          _buildSection3(context, student),
        ],
      ),
    );
  }

  Widget _buildProfile(context, Student? student) {
    return Column(
      children: [
        CustomImage(
          student?.profilePic ?? "",
          width: 70,
          height: 70,
          radius: 20,
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          "${student?.firstName} ${student?.lastName}",
          // User's name (static data)
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildRecord(context, Student? student, List<MyCourse> myCourses) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: SettingBox(
            title:
                AppLocalizations.of(context)!.account_courses(myCourses.length),
            // Localized text
            icon: "assets/icons/work.svg",
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: SettingBox(
            title: AppLocalizations.of(context)!
                .account_hours(Helpers.getTotalWatchTimeFormatted(myCourses)),
            // Localized text
            icon: "assets/icons/time.svg",
          ),
        ),
      ],
    );
  }

  Widget _buildSection1(context, Student? student) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: AppColor.cardColor,
        boxShadow: [
          BoxShadow(
            color: AppColor.shadowColor.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          SettingItem(
            title: AppLocalizations.of(context)!.settings_title,
            // Localized text
            fullIcon: Icon(
              Icons.settings_applications_rounded,
              color: AppColor.primary,
              size: 28,
            ),
            leadingIcon: "assets/icons/setting.svg",
            bgIconColor: AppColor.blue,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingPage()),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(left: 45),
            child: Divider(
              height: 0,
              color: Colors.grey.withValues(alpha: 0.8),
            ),
          ),
          SettingItem(
            title: AppLocalizations.of(context)!.payments_title,
            // Localized text
            fullIcon: Icon(
              Icons.wallet_rounded,
              color: AppColor.primary,
              size: 28,
            ),
            leadingIcon: "assets/icons/wallet.svg",
            bgIconColor: AppColor.green,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PaymentPage()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSection2(context, Student? student) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: AppColor.cardColor,
        boxShadow: [
          BoxShadow(
            color: AppColor.shadowColor.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          SettingItem(
            title: AppLocalizations.of(context)!.privacy_title,
            // Localized text
            fullIcon: Icon(
              Icons.shield,
              color: AppColor.primary,
              size: 28,
            ),
            leadingIcon: "assets/icons/shield.svg",
            bgIconColor: AppColor.orange,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PrivacyPage()),
              );
            },
          ),
          SettingItem(
            title: AppLocalizations.of(context)!.our_contact_info,
            // Localized text
            fullIcon: Icon(
              Icons.contact_mail_rounded,
              color: AppColor.primary,
              size: 28,
            ),
            leadingIcon: "assets/icons/shield.svg",
            bgIconColor: AppColor.orange,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OurContactInfo()),
              );
            },
          ),
          SettingItem(
            title: AppLocalizations.of(context)!.licenses,
            // Localized text
            fullIcon: Icon(
              Icons.local_police_rounded,
              color: AppColor.primary,
              size: 28,
            ),
            leadingIcon: "assets/icons/shield.svg",
            bgIconColor: AppColor.orange,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LicensesPage()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSection3(BuildContext context, Student? student) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: AppColor.cardColor,
        boxShadow: [
          BoxShadow(
            color: AppColor.shadowColor.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: SettingItem(
        title: AppLocalizations.of(context)!.account_logout, // Localized text
        fullIcon: Icon(
          Icons.logout_rounded,
          color: AppColor.red,
          size: 28,
        ),
        leadingIcon: "assets/icons/logout.svg",
        bgIconColor: AppColor.darker,
        onTap: () {
          showLogoutDialog(
            context: context,
            title: AppLocalizations.of(context)!.confirm_logout,
            // Translated title
            message: AppLocalizations.of(context)!.confirm_logout_message,
            // Translated message
            confirmText: AppLocalizations.of(context)!.logout,
            // Translated confirm text
            cancelText: AppLocalizations.of(context)!.cancel,
            // Translated cancel text
            onConfirm: () {
              // Handle logout logic
              final authProvider =
                  Provider.of<AuthProvider>(context, listen: false);
              authProvider.logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          );
        },
      ),
    );
  }
}
