import 'package:flutter/material.dart';
import '../../theme/color.dart';
import '../../widgets/appbar.dart';

class BookmarkPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBgColor,
      appBar: const CustomAppBar(title: 'Bookmark'),
      body: ListView.builder(
        itemCount: 10, // Assuming you have a list of bookmarks
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.bookmark, color: AppColor.primary),
            title: Text('Bookmark $index',
                style: TextStyle(color: AppColor.textColor)),
            onTap: () {
              // Handle Bookmark tap
            },
          );
        },
      ),
    );
  }
}
