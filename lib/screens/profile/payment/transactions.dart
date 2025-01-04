import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart'; // Import Provider for AuthProvider
import '../../../theme/color.dart';
import '../../../utils/translation.dart';
import '../../../widgets/appbar.dart';
import '../../../providers/auth_provider.dart'; // AuthProvider for fetching transactions
import '../../../models/transaction.dart'; // Transaction model

class TransactionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: localization.transactions_title,
      ),
      body: authProvider.isLoading
          ? Center(
              child:
                  CircularProgressIndicator(), // Show a loader while transactions are loading
            )
          : authProvider.studentTransactions.isEmpty
              ? Center(
                  child: Text(
                    localization.transactions_empty,
                    style: TextStyle(fontSize: 18, color: AppColor.darker),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: authProvider.studentTransactions.length,
                  itemBuilder: (context, index) {
                    final transaction = authProvider.studentTransactions[index];
                    return GestureDetector(
                      onTap: () =>
                          _showTransactionDetails(context, transaction),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 6,
                              offset: Offset(0, 3),
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
                                transaction.course.title,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),

                              // Transaction Date
                              Text(
                                localization.transaction_date(
                                  transaction.createdAt
                                      .toLocal()
                                      .toString()
                                      .split(' ')[0], // Format date
                                ),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColor.mainColor,
                                ),
                              ),
                              const SizedBox(height: 8),

                              // Status and Price
                              Text(
                                "${localization.transaction_status_label}: ${TranslationHelper.getTranslatedStatus(localization, transaction.status)} - ${transaction.amount.toStringAsFixed(2)} DZD",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: _getStatusColor(transaction
                                      .status), // Dynamically set status color
                                  fontWeight: FontWeight
                                      .bold, // Optional: Highlight the text
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  // Show dialog for transaction details
  void _showTransactionDetails(BuildContext context, Transaction transaction) {
    final localization = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          title: Row(
            children: [
              // Course Icon (assuming you have a placeholder if no icon available)
              CircleAvatar(
                radius: 20.0,
                backgroundImage: transaction.course.icon.url.startsWith('http')
                    ? NetworkImage(transaction.course.icon.url)
                    : AssetImage('assets/images/default_avatar.png')
                        as ImageProvider,
                onBackgroundImageError: (_, __) {
                  // Optional: Log or handle the image loading error.
                },
                child: !transaction.course.icon.url.startsWith('http')
                    ? Icon(
                        Icons.person_rounded,
                        color: Colors.white,
                      )
                    : null, // No child needed if the image is valid.
              ),
              const SizedBox(width: 12),
              // Course Title
              Expanded(
                child: Text(
                  transaction.course.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  overflow:
                      TextOverflow.ellipsis, // Handle long titles gracefully
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Transaction Date
                Text(
                  "${localization.transaction_date_label}: ${transaction.createdAt.toLocal().toString().split(' ')[0]}",
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColor.mainColor,
                  ),
                ),
                const SizedBox(height: 8),

                // Transaction Amount
                Text(
                  "${localization.transaction_amount_label}: ${transaction.amount.toStringAsFixed(2)} DZD",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),

                // Transaction Status
                Text(
                  "${localization.transaction_status_label}: ${TranslationHelper.getTranslatedStatus(localization, transaction.status)}",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 8),

                // Payment Method
                if (transaction.paymentMethod != null)
                  Text(
                    "${localization.transaction_payment_method_label}: ${transaction.paymentMethod}",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                const SizedBox(height: 8),
                // Course Duration
                Text(
                  "${localization.chapters}: ${transaction.course.chapters.length}",
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColor.mainColor,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Close the dialog
              child: Text(localization.close_button),
            ),
          ],
        );
      },
    );
  }
}

Color _getStatusColor(String status) {
  switch (status) {
    case 'PENDING':
      return Colors.orange; // Pending: Orange
    case 'FAILED':
      return Colors.red; // Failed: Red
    case 'PAID':
      return Colors.green; // Paid: Green
    default:
      return Colors.grey; // Default color (e.g., unknown status)
  }
}
