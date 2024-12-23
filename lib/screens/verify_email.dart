import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:online_course/services/auth_service.dart';
import 'package:online_course/theme/color.dart';
import 'package:online_course/widgets/snackbar.dart';

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
      final result = await AuthService.verifyEmail(widget.token);

      if (result.success) {
        if (mounted) {
          SnackBarHelper.showSuccessSnackBar(
            context,
            AppLocalizations.of(context)!.email_verification_success,
          );
          Navigator.pushReplacementNamed(context, '/login');
        }
      } else {
        setState(() => _errorMessage = result.message);
        SnackBarHelper.showErrorSnackBar(context, result.message);
      }
    } catch (e) {
      setState(() => _errorMessage = e.toString());
      SnackBarHelper.showErrorSnackBar(context, e.toString());
    } finally {
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
                    ? AppLocalizations.of(context)!.email_verification_in_progress
                    : _errorMessage,
                style: TextStyle(color: AppColor.textColor),
              ),
      ),
    );
  }
}