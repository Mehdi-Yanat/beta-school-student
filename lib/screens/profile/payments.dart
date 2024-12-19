import 'package:flutter/material.dart';
import '../../theme/color.dart';
import '../../widgets/appbar.dart';

class PaymentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBgColor,
      appBar: const CustomAppBar(title: 'Payments'),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.credit_card, color: AppColor.primary),
            title:
                Text('Add Card', style: TextStyle(color: AppColor.textColor)),
            onTap: () {
              // Handle Add Card tap
            },
          ),
          ListTile(
            leading: Icon(Icons.payment, color: AppColor.primary),
            title: Text('Payment Methods',
                style: TextStyle(color: AppColor.textColor)),
            onTap: () {
              // Handle Payment Methods tap
            },
          ),
          ListTile(
            leading: Icon(Icons.history, color: AppColor.primary),
            title: Text('Transaction History',
                style: TextStyle(color: AppColor.textColor)),
            onTap: () {
              // Handle Transaction History tap
            },
          ),
        ],
      ),
    );
  }
}
