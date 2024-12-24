import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:online_course/providers/auth_provider.dart';
import 'package:online_course/services/auth_service.dart';
import 'package:online_course/theme/color.dart';
import 'package:online_course/widgets/snackbar.dart';
import 'package:provider/provider.dart';

class VerifyEmailScreen extends StatefulWidget {
  final String token;

  const VerifyEmailScreen({super.key, required this.token});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _verifyEmail();
  }

  Future<void> _verifyEmail() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      print("Starting email verification...");
      final result = await AuthService.verifyEmail(widget.token);
      print("result  ${result}");
      if (result) {
        if (mounted) {
          print("Email verification successful");
          SnackBarHelper.showSuccessSnackBar(
            context,
            AppLocalizations.of(context)!.email_verification_success,
          );
          print("Navigating to /root...");
          Navigator.pushReplacementNamed(context, '/root');
          print("Refreshing profile...");
          final authProvider = context.read<AuthProvider>();
          await authProvider.refreshProfile();
          print("Profile refresh completed successfully");
        }
      } else {
        print("Email verification failed");
        setState(() => _errorMessage =
            AppLocalizations.of(context)!.email_verification_failed);
        SnackBarHelper.showErrorSnackBar(
            context, AppLocalizations.of(context)!.email_verification_failed);
      }
    } catch (e) {
      print("Error during email verification: $e");
      setState(() => _errorMessage = e.toString());
      SnackBarHelper.showErrorSnackBar(context, e.toString());
    } finally {
      print("Email verification process completed");
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBgColor,
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : Text(
                _errorMessage.isEmpty
                    ? AppLocalizations.of(context)!
                        .email_verification_in_progress
                    : _errorMessage,
                style: TextStyle(color: AppColor.textColor),
              ),
      ),
    );
  }
}
