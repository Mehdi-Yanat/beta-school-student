import 'package:flutter/material.dart';
import 'package:online_course/theme/color.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../providers/auth_provider.dart';
import '../../providers/course_provider.dart';

class PaymentSuccessPage extends StatelessWidget {
  final String checkoutId;

  const PaymentSuccessPage({super.key, required this.checkoutId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.payment_success_title,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: PaymentStatusContent(checkoutId: checkoutId),
    );
  }
}

class PaymentStatusContent extends StatefulWidget {
  final String checkoutId;

  const PaymentStatusContent({super.key, required this.checkoutId});

  @override
  State<PaymentStatusContent> createState() => _PaymentStatusContentState();
}

class _PaymentStatusContentState extends State<PaymentStatusContent> {
  @override
  void initState() {
    super.initState();
    _fetchTransaction();
  }

  Future<void> _fetchTransaction() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final courseProvider = Provider.of<CourseProvider>(context, listen: false);
    await authProvider.fetchTransactionByCheckoutId(widget.checkoutId);
    await courseProvider.fetchMyCourses(context);
    await courseProvider.fetchCourse(
        authProvider.transactionDetails?['courseId'], context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        if (authProvider.isTransactionLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (authProvider.transactionError != null) {
          return _buildErrorView(
              AppLocalizations.of(context)!.no_transaction_found);
        }

        final transaction = authProvider.transactionDetails;
        if (transaction == null) {
          return _buildNoTransactionView();
        }

        return _buildTransactionDetailsView(context, transaction);
      },
    );
  }

  Widget _buildErrorView(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 60),
          const SizedBox(height: 16),
          Text(
            error,
            style: const TextStyle(color: Colors.red, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          _buildRetryButton(),
        ],
      ),
    );
  }

  Widget _buildNoTransactionView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context)!.no_transaction_found,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          _buildRetryButton(),
        ],
      ),
    );
  }

  Widget _buildTransactionDetailsView(
      BuildContext context, Map<String, dynamic> transaction) {
    final isSuccess = transaction['status'] == 'PAID';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
              isSuccess ? Image.asset("assets/images/payment-ok.png", width: 200,) : Image.asset("assets/images/fail.png"),
            const SizedBox(height: 20),
            Text(
              isSuccess
                  ? AppLocalizations.of(context)!.payment_success_title
                  : AppLocalizations.of(context)!.payment_failed,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            TransactionDetails(transaction: transaction),
            const SizedBox(height: 30),
            _buildHomeButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildRetryButton() {
    return ElevatedButton(
      onPressed: _fetchTransaction,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      child: Text(
        AppLocalizations.of(context)!.retry_button,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildHomeButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Provider.of<CourseProvider>(context, listen: false)
            .fetchMyCourses(context);
        Navigator.pop(context);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.primary,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      ),
      child: Text(
        AppLocalizations.of(context)!.back_to_home_button,
        style: const TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }
}

class TransactionDetails extends StatelessWidget {
  final Map<String, dynamic> transaction;

  const TransactionDetails({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          _buildDetailRow(
            AppLocalizations.of(context)!.transaction_id_label,
            transaction['id'],
          ),
          const SizedBox(height: 8),
          _buildDetailRow(
            AppLocalizations.of(context)!.amount_label,
            '${transaction['amount']}',
          ),
          if (transaction['date'] != null) ...[
            const SizedBox(height: 8),
            _buildDetailRow(
              AppLocalizations.of(context)!.date_label,
              transaction['date'],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: const TextStyle(fontSize: 14),
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
