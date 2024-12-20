import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import localization
import 'package:online_course/utils/data.dart';
import 'package:online_course/widgets/chat_item.dart';
import 'package:online_course/widgets/custom_textfield.dart';

class AnnouncesPage extends StatefulWidget {
  const AnnouncesPage({Key? key}) : super(key: key);

  @override
  _AnnouncesPageState createState() => _AnnouncesPageState();
}

class _AnnouncesPageState extends State<AnnouncesPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          _buildHeader(context),
          _buildChats(),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 60, 0, 5),
      child: Column(
        children: [
          Text(
            AppLocalizations.of(context)!.announces_title, // Localized title
            style: TextStyle(
              fontSize: 28,
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 15),
          CustomTextBox(
            hint: AppLocalizations.of(context)!
                .search_hint, // Localized hint text
            prefix: Icon(
              Icons.search,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChats() {
    return ListView(
      padding: EdgeInsets.only(top: 10),
      shrinkWrap: true,
      children: List.generate(
        chats.length,
        (index) => ChatItem(
          chats[index],
        ),
      ),
    );
  }
}
