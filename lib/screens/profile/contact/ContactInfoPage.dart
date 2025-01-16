import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:online_course/theme/color.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../widgets/SocialButton.dart';
import '../../../widgets/appbar.dart'; // Import localization

class OurContactInfo extends StatelessWidget {
  final String schoolOneAddress = "Beta Prime School PC6M+58G, Bir El Djir";

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: CustomAppBar(title: localization.contact_info),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // // Effective Date
              // buildEffectiveDateSection(localization),

              SizedBox(height: 24),

              // Section 1: Personal Information
              buildSection(
                title: localization.address,
                description: "PC6M+58G, Boulevard Des Lions, Bir El Djir",
                icon: Icons.map_rounded,
                isLink: true,
                onTap: () => _openGoogleMaps(schoolOneAddress)
              ),
              SizedBox(height: 24),
              buildSection(
                title: localization.phone,
                description: "0791941612",
                icon: Icons.phone_rounded,
                isLink: true,
                onTap: () => _makePhoneCall("0791941612")
              ),

              SizedBox(height: 24),

              // Section 3: Data Sharing
              buildSection(
                title: localization.email,
                description: "contact@betaprimeschool.com",
                icon: Icons.email_rounded,
                isLink: true,
                onTap: () => _sendEmail("contact@betaprimeschool.com")
              ),

              SizedBox(height: 24),
              SocialsBtn(platform: 'facebook', onPressed: () {_openFacebook("BETA-School-soutien-scolaire--100072436272946");},),
              SocialsBtn(platform: 'tiktok',onPressed: () {_openTikTok("beta_prime_school");},),
              SocialsBtn(platform: 'instagram',onPressed: () {_openInstagram("betaprimeschool");},)
              //
              // // Contact Us
              // buildContactSection(localization),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openFacebook(facebookId) async {
    final Uri fbAppUri = Uri.parse('fb://profile/$facebookId'); // Opens Facebook app
    final Uri fbWebUri = Uri.parse('https://www.facebook.com/$facebookId'); // Fallback to the web
    if (await canLaunchUrl(fbAppUri)) {
      await launchUrl(fbAppUri);
    } else {
      await launchUrl(fbWebUri);
    }
  }

  // Function to deeplink to Instagram
  Future<void> _openInstagram(instagramUsername) async {
    final Uri instaAppUri = Uri.parse('instagram://user?username=$instagramUsername'); // Opens Instagram app
    final Uri instaWebUri = Uri.parse('https://www.instagram.com/$instagramUsername'); // Fallback to the web
    if (await canLaunchUrl(instaAppUri)) {
      await launchUrl(instaAppUri);
    } else {
      await launchUrl(instaWebUri);
    }
  }

  // Function to deeplink to TikTok
  Future<void> _openTikTok(tiktokUsername) async {
    final Uri tiktokUri = Uri.parse('https://www.tiktok.com/@$tiktokUsername'); // TikTok uses only web URLs
    if (await canLaunchUrl(tiktokUri)) {
      await launchUrl(tiktokUri);
    } else {
      throw 'Could not launch TikTok profile';
    }
  }

  void _sendEmail(email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=Hello&body=How are you?', // Add subject and body here
    );
    await launchUrl(emailUri);
  }

  void _openGoogleMaps(String address) async {
    final query = Uri.encodeComponent(address);
    final url = "https://www.google.com/maps/search/?api=1&query=$query";
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not open the map.';
    }
  }

  void _makePhoneCall(String number) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: "+213" + number,
    );

    print(launchUri);
    await launchUrl(launchUri);
  }

  // Helper to create reusable sections
  Widget buildSection({
    required String title,
    required String description,
    required IconData icon,
    bool isLink = false,
    void Function()? onTap
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.blueAccent, size: 24),
            SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        isLink ? GestureDetector(
          onTap: onTap,
          child:         Text(
            description,
            style: TextStyle(
              fontSize: 15,
              color: AppColor.secondary,
              height: 1.5,
              decoration: TextDecoration.underline
            ),
          ),
        ) :
        Text(
          description,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[800],
            height: 1.5,
          ),
        ),
      ],
    );
  }

  // Helper to build Contact Us section
  Widget buildContactSection(AppLocalizations localization) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.email, color: Colors.green, size: 24),
            SizedBox(width: 8),
            Text(
              localization.contact_us(''),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        TextButton.icon(
          onPressed: () {
            // Add email functionality or navigation
          },
          icon: Icon(Icons.mail, color: Colors.blueAccent),
          label: Text(
            'support@yourapp.com',
            style: TextStyle(
              fontSize: 14,
              color: Colors.blue,
            ),
          ),
        ),
      ],
    );
  }

  // Helper to build Effective Date section
  Widget buildEffectiveDateSection(AppLocalizations localization) {
    return Row(
      children: [
        Icon(Icons.calendar_today, color: Colors.orangeAccent, size: 20),
        SizedBox(width: 8),
        Text(
          '${localization.effective_date}: 2025',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
