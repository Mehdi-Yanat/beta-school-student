import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../widgets/appbar.dart'; // Import localization

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: CustomAppBar(title: localization.privacy_policy_title),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Effective Date
              buildEffectiveDateSection(localization),

              SizedBox(height: 24),

              // Section 1: Personal Information
              buildSection(
                title: localization.personal_info_section,
                description: localization.personal_info_description,
                icon: Icons.person,
              ),

              SizedBox(height: 24),

              // Section 2: Usage Information
              buildSection(
                title: localization.usage_info_section,
                description: localization.usage_info_description,
                icon: Icons.info_outline,
              ),

              SizedBox(height: 24),

              // Section 3: Data Sharing
              buildSection(
                title: localization.data_sharing_section,
                description: localization.data_sharing_description,
                icon: Icons.share,
              ),

              SizedBox(height: 24),

              // Contact Us
              buildContactSection(localization),
            ],
          ),
        ),
      ),
    );
  }

  // Helper to create reusable sections
  Widget buildSection({
    required String title,
    required String description,
    required IconData icon,
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
