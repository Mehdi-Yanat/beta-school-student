import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../theme/color.dart'; // Assuming you have theme colors defined in this file
import '../../../widgets/appbar.dart'; // CustomAppBar for consistent UI

class Transaction {
  final String courseName; // Name of the purchased course
  final String date; // Purchase date
  final double amount; // Paid amount in DZD

  Transaction(
      {required this.courseName, required this.date, required this.amount});
}

class TransactionsPage extends StatelessWidget {
  // Example transaction data
  final List<Transaction> transactions = [
    Transaction(
        courseName: "Flutter Basics", date: "2023-10-01", amount: 4500.0),
    Transaction(
        courseName: "Advanced Python", date: "2023-09-15", amount: 7000.0),
    Transaction(
        courseName: "UI/UX Design Principles",
        date: "2023-08-20",
        amount: 3000.0),
  ];

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: CustomAppBar(
        title: localization.transactions_title,
      ),
      body: transactions.isEmpty
          ? Center(
              child: Text(
                localization.transactions_empty,
                style: TextStyle(fontSize: 18, color: AppColor.darker),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                return Container(
                  margin:
                      const EdgeInsets.only(bottom: 16), // Space between cards
                  decoration: BoxDecoration(
                    color: Colors.white, // White background
                    borderRadius: BorderRadius.circular(8), // Rounded corners
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black
                            .withValues(alpha: 0.1), // Slight shadow
                        blurRadius: 6,
                        offset: Offset(0, 3), // Shadow position
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Course Name (Bold and prominent)
                        Text(
                          localization
                              .transaction_course(transaction.courseName),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Transaction Date
                        Text(
                          localization.transaction_date(transaction.date),
                          style: TextStyle(
                            fontSize: 14,
                            color:
                                AppColor.mainColor, // Use your main theme color
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Transaction Amount in DZD
                        Text(
                          localization.transaction_amount(
                            transaction.amount.toStringAsFixed(2),
                          ),
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.green,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
