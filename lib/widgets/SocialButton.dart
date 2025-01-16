import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/color.dart';

class SocialsBtn extends StatelessWidget {
  final String platform;

  final Function() onPressed;
  const SocialsBtn({
    required this.platform,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 54,
        margin: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(

          )],
          border: Border.all(width: 1, color: AppColor.darkBackground),
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        child: TextButton(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(AppColor.darkBackground),
              shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)))
          ),
          child: buildSocialButton(),
          onPressed: onPressed,
        ));
  }

  Row buildSocialButton() {
    if (platform == 'facebook') {
      return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.facebook_rounded, color: Colors.white, size: 30,),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text("Facebook",
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                ],
              );
    } else if (platform == 'tiktok') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.tiktok_rounded, color: Colors.white, size: 30,),
          const SizedBox(
            width: 10,
          ),
          const Text("TikTok",
              style: TextStyle(color: Colors.white, fontSize: 16)),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset("assets/icons/icons8-instagram.svg", color: Colors.white, width: 30,),
          const SizedBox(
            width: 10,
          ),
          const Text("Instagram",
              style: TextStyle(color: Colors.white, fontSize: 16)),
        ],
      );
    }
  }
}
