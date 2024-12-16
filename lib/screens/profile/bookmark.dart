import 'package:flutter/material.dart';
import '../../theme/color.dart';

class BookmarkPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBgColor,
      appBar: AppBar(
        title: Text('Bookmarks', style: TextStyle(color: AppColor.textColor)),
        backgroundColor: AppColor.appBarColor,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
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
