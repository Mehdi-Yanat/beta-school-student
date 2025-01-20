import 'package:flutter/material.dart';

import '../theme/color.dart';

class LikeListTile extends StatelessWidget {
  const LikeListTile(
      {Key? key,
      required this.title,
      required this.likes,
      required this.subtitle,
      this.subtitle2,
      required this.imgUrl,
      this.color = Colors.grey})
      : super(key: key);
  final String title;
  final String likes;
  final String subtitle;
  final String? subtitle2;
  final Color color;
  final String imgUrl;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.all(0),
      leading: Container(
        width: 60,
        child: AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      imgUrl,
                    ))),
          ),
        ),
      ),
      title: Text(
        title,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Row(
        children: [
          Icon(Icons.remove_red_eye_rounded, color: color, size: 20),
          SizedBox(
            width: 3,
          ),
          Text(likes),
          Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(width: 4, height: 4),
              )),
          Text(subtitle),
          SizedBox(
            width: 8,
          ),
          if (subtitle2 != null)
            Icon(Icons.star_rounded, color: color, size: 20),
          SizedBox(
            width: 3,
          ),
          if (subtitle2 != null) Text(subtitle2!)
        ],
      ),
      trailing: Icon(
        Icons.remove_red_eye_sharp,
        color: AppColor.primary,
      ),
    );
  }
}

class LikeButton extends StatefulWidget {
  const LikeButton(
      {Key? key, required this.onPressed, this.color = Colors.black12})
      : super(key: key);
  final Function onPressed;
  final Color color;

  @override
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: IconButton(
      icon: Icon(isLiked ? Icons.favorite : Icons.favorite_border,
          color: widget.color),
      onPressed: () {
        setState(() {
          isLiked = !isLiked;
        });
        widget.onPressed();
      },
    ));
  }
}
