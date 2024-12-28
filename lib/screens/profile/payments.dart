import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import localization
import 'package:online_course/screens/profile/payment/methods.dart';
import 'package:online_course/screens/profile/payment/transactions.dart';
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
            leading: Icon(Icons.payment, color: AppColor.primary),
            title: Text(
              AppLocalizations.of(context)!.payment_methods,
              style: TextStyle(color: AppColor.mainColor),
            ),
            onTap: () {
              // Handle Payment Methods tap
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PaymentMethodsScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.history, color: AppColor.primary),
            title: Text(
              AppLocalizations.of(context)!.transaction_history,
              style: TextStyle(color: AppColor.mainColor),
            ),
            onTap: () {
              // Handle Transaction History tap
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TransactionsPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
