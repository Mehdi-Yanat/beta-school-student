import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../widgets/appbar.dart'; // Flutter localization package

class PaymentMethodsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.payment_methods,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Title to explain purpose of the screen
            Text(
              AppLocalizations.of(context)!
                  .available_payment_methods, // Localized subtitle
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),

            // Image containing all payment methods
            Image.asset(
              'assets/images/dab-banque.jpg',
              width: double.infinity, // Take full width of the screen
              height: 150, // Set height for the image
              fit: BoxFit.contain, // Adjust image to fit properly
            ),

            const SizedBox(height: 16),

            // Description for payment methods (localized in English/French/Arabic)
            Text(
              AppLocalizations.of(context)!
                  .description, // Localized description
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
