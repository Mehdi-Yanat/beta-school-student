import 'package:flutter/material.dart';
import 'package:online_course/widgets/appbar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import localization

class LicensesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.licenses,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.attributing_authors + " :",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              AttributionLink(
                text: "Basic education icons created by Falcone - Flaticon",
                url: "https://www.flaticon.com/free-icons/basic-education",
              ),
              AttributionLink(
                text: "Calculus icons created by Freepik - Flaticon",
                url: "https://www.flaticon.com/free-icons/calculus",
              ),
              AttributionLink(
                text: "Chemistry icons created by Rasama studio - Flaticon",
                url: "https://www.flaticon.com/free-icons/chemistry",
              ),
              AttributionLink(
                text: "Atom icons created by iconixar - Flaticon",
                url: "https://www.flaticon.com/free-icons/atom",
              ),
              AttributionLink(
                text: "Study icons created by Freepik - Flaticon",
                url: "https://www.flaticon.com/free-icons/study",
              ),
              AttributionLink(
                text: "Quran icons created by Us and Up - Flaticon",
                url: "https://www.flaticon.com/free-icons/quran",
              ),
              AttributionLink(
                text:
                    "Arabic language icons created by Laisa Islam Ani - Flaticon",
                url: "https://www.flaticon.com/free-icons/arabic-language",
              ),
              AttributionLink(
                text: "French icons created by Freepik - Flaticon",
                url: "https://www.flaticon.com/free-icons/french",
              ),
              AttributionLink(
                text: "Basic education icons created by Falcone - Flaticon",
                url: "https://www.flaticon.com/free-icons/basic-education",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AttributionLink extends StatelessWidget {
  final String text;
  final String url;

  const AttributionLink({required this.text, required this.url});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: () => _launchUrl(url),
        child: Text(
          text,
          style: TextStyle(
              color: Colors.blue, decoration: TextDecoration.underline),
        ),
      ),
    );
  }

  void _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
