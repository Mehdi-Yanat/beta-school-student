import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FloatingActionButtonFb3 extends StatelessWidget {
  final Function() onPressed;
  final Widget icon;
  final Color color;
  final String? tag;
  const FloatingActionButtonFb3(
      {required this.onPressed,
        required this.icon,
        this.color = Colors.blue,
        Key? key, this.tag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: color,
      onPressed: onPressed,
      child: icon,
      heroTag: tag,
    );
  }
}