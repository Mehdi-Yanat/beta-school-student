import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import localization
import '../../theme/color.dart';
import '../../widgets/appbar.dart';

class PaymentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBgColor,
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.payments_title,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.credit_card, color: AppColor.primary),
            title: Text(
              AppLocalizations.of(context)!.add_card,
              style: TextStyle(color: AppColor.textColor),
            ),
            onTap: () {
              // Handle Add Card tap
            },
          ),
          ListTile(
            leading: Icon(Icons.payment, color: AppColor.primary),
            title: Text(
              AppLocalizations.of(context)!.payment_methods,
              style: TextStyle(color: AppColor.textColor),
            ),
            onTap: () {
              // Handle Payment Methods tap
            },
          ),
          ListTile(
            leading: Icon(Icons.history, color: AppColor.primary),
            title: Text(
              AppLocalizations.of(context)!.transaction_history,
              style: TextStyle(color: AppColor.textColor),
            ),
            onTap: () {
              // Handle Transaction History tap
            },
          ),
        ],
      ),
    );
  }
}
