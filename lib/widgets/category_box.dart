import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:online_course/theme/color.dart';
import 'package:online_course/utils/translation.dart';

class CategoryBox extends StatelessWidget {
  CategoryBox({
    Key? key,
    required this.data,
    this.isSelected = false,
    this.onTap,
    this.selectedColor = AppColor.actionColor,
  }) : super(key: key);

  final data;
  final Color selectedColor;
  final bool isSelected;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.fastOutSlowIn,
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: isSelected ? Color(0xC1DAF2FF) : Colors.white,
              boxShadow: !isSelected
                  ? [
                      BoxShadow(
                        color: AppColor.shadowColor.withValues(alpha: 0.1),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: Offset(1, 1),
                      )
                    ]
                  : [],
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              data["icon"],
              // color: isSelected ? Colors.white : AppColor.mainColor,
              width: 50,
              height: 50,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            TranslationHelper.getTranslatedSubject(context, data["id"]),
            maxLines: 1,
            overflow: TextOverflow.fade,
            style: TextStyle(
              color: AppColor.mainColor,
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }
}
