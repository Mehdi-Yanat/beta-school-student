import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DialogFb3 extends StatelessWidget {
  const DialogFb3({
    Key? key,
required this.imgUrl,
    required this.title,
    required this.text,
  }) : super(key: key);

  final primaryColor = const Color(0xff4338CA);
  final secondaryColor = const Color(0xff6D28D9);
  final accentColor = const Color(0xffffffff);
  final backgroundColor = const Color(0xffffffff);
  final errorColor = const Color(0xffEF4444);

  final String imgUrl;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        // width: MediaQuery.of(context).size.width / 1,
        // height: MediaQuery.of(context).size.height / 2.5,
        constraints: BoxConstraints(
          maxHeight: 500,
        ),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
            gradient: LinearGradient(colors:[primaryColor, secondaryColor]),
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                  offset: const Offset(12, 26),
                  blurRadius: 50,
                  spreadRadius: 0,
                  color: Colors.grey.withOpacity(.1)),
            ]),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title,
                style: TextStyle(
                    color: accentColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 15,
            ),
            Image.network(imgUrl),
            const SizedBox(
              height: 12,
            ),
            Text(text,
                style: TextStyle(
                    color: accentColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w300)),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}