import 'package:flutter/material.dart';
import '../../theme/color.dart';
import '../../widgets/appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import localization

class BookmarkPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBgColor,
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.bookmark_title,
      ),
      body: ListView.builder(
        itemCount: 10, // Assuming you have a list of bookmarks
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.bookmark, color: AppColor.primary),
            title: Text(
              '${AppLocalizations.of(context)!.bookmark_item} $index',
              style: TextStyle(color: AppColor.textColor),
            ),
            onTap: () {
              // Handle Bookmark tap
            },
          );
        },
      ),
    );
  }
}
