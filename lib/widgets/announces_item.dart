import 'package:flutter/material.dart';
import 'custom_image.dart';

class AnnouncesItem extends StatelessWidget {
  const AnnouncesItem(
    this.data, {
    Key? key,
    this.onTap,
    this.profileSize = 50,
  }) : super(key: key);

  final Map<String, dynamic> data;
  final GestureTapCallback? onTap;
  final double profileSize;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.fromLTRB(10, 12, 10, 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(1, 1),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildPhoto(),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                children: [
                  buildNameAndTime(),
                  const SizedBox(
                    height: 5,
                  ),
                  _buildTextAndNotified(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextAndNotified() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            data['message'],
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 13),
          ),
        ),
        /*
        if (isNotified)
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: ChatNotify(
              number: 5,
              boxSize: 17,
              color: AppColor.red,
            ),
          )*/
      ],
    );
  }

  Widget _buildPhoto() {
    return CustomImage(
      data['image'],
      width: profileSize,
      height: profileSize,
    );
  }

  Widget buildNameAndTime() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Text(
            data['name'] ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(width: 5),
        Text(
          data['timeAgo'],
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
