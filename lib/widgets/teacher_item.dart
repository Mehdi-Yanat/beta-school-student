import 'package:flutter/material.dart';
import 'package:online_course/theme/color.dart';
import 'package:online_course/widgets/custom_image.dart';

import '../utils/translation.dart';

class TeacherItem extends StatelessWidget {
  const TeacherItem({
    Key? key,
    required this.data,
    this.onTap,
  }) : super(key: key);

  final data;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isNetwork = data["image"].startsWith("https");

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(right: 10),
        padding: EdgeInsets.all(20),
        width: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: AppColor.primary.withAlpha(50),
              spreadRadius: 2,
              blurRadius: 9,
              offset: Offset(2, 1), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          children: [
            CustomImage(
              data["image"],
              radius: 15,
              height: 80,
              width: 80,
              isNetwork: isNetwork,
            ),
            const SizedBox(
              width: 10,
            ),
            _buildInfo(context)
          ],
        ),
      ),
    );
  }

  Widget _buildInfo(context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data["name"],
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColor.mainColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            TranslationHelper.getTranslatedSubject(
              context,
              data['subject'],
            ),
            style: TextStyle(fontSize: 14, color: AppColor.darker),
          ),
          Text(
            data["institution"],
            style: TextStyle(fontSize: 12, color: AppColor.mainColor),
          ),
          const SizedBox(height: 10),
          _buildExperienceAndRate()
        ],
      ),
    );
  }

  Widget _buildExperienceAndRate() {
    return Row(
      children: [
        Icon(Icons.people_alt_rounded, color: AppColor.darker, size: 14),
        const SizedBox(width: 5),
        Text(
          data["totalEnrolledStudents"].toString(),
          style: TextStyle(fontSize: 12, color: AppColor.darker),
        ),
        const SizedBox(width: 15),
        Icon(Icons.star, color: AppColor.yellow, size: 14),
        const SizedBox(width: 5),
        Text(
          data["review"],
          style: TextStyle(fontSize: 12, color: AppColor.darker),
        )
      ],
    );
  }
}
