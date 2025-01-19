import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:online_course/providers/auth_provider.dart';
import 'package:online_course/services/auth_service.dart';
import 'package:online_course/theme/color.dart';
import 'package:online_course/utils/storage.dart';
import 'package:online_course/widgets/AlertDialogue.dart';
import 'package:online_course/widgets/appbar.dart';
import 'package:online_course/widgets/gradient_button.dart';
import 'package:online_course/widgets/snackbar.dart';
import 'package:provider/provider.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({Key? key}) : super(key: key);

  @override
  _SecurityScreenState createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  final _emailFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  bool _isLoadingEmail = false;
  bool _isLoadingPassword = false;
  String _errorMessage = '';

  Future<void> _updateEmail() async {
    if (!_emailFormKey.currentState!.validate()) return;

    setState(() {
      _isLoadingEmail = true;
      _errorMessage = '';
    });

    try {
      final token = await StorageService.getToken("accessToken");
      if (token == null) throw Exception('No auth token found');

      final result =
          await AuthService.updateEmail(token, _emailController.text);

      if (result.success) {
        SnackBarHelper.showSuccessSnackBar(
          context,
          AppLocalizations.of(context)!.email_update_success,
        );
        _emailController.clear();
      } else {
        setState(() => _errorMessage = result.message);
        SnackBarHelper.showErrorSnackBar(context, result.message);
      }
    } catch (e) {
      setState(() => _errorMessage = e.toString());
      SnackBarHelper.showErrorSnackBar(context, e.toString());
    } finally {
      setState(() => _isLoadingEmail = false);
    }
  }

  Future<void> _updatePassword() async {
    if (!_passwordFormKey.currentState!.validate()) return;

    setState(() {
      _isLoadingPassword = true;
      _errorMessage = '';
    });

    try {
      final token = await StorageService.getToken("accessToken");
      if (token == null) throw Exception('No auth token found');

      final result = await AuthService.updatePassword(
        token,
        _currentPasswordController.text,
        _newPasswordController.text,
      );

      if (result.success) {
        SnackBarHelper.showSuccessSnackBar(
          context,
          AppLocalizations.of(context)!.password_update_success,
        );
        _currentPasswordController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();
      } else {
        setState(() => _errorMessage = result.message);
        SnackBarHelper.showErrorSnackBar(context, result.message);
      }
    } catch (e) {
      setState(() => _errorMessage = e.toString());
      SnackBarHelper.showErrorSnackBar(context, e.toString());
    } finally {
      setState(() => _isLoadingPassword = false);
    }
  }

  @override
  void initState() {
    super.initState();
    // Set initial email value after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final email =
          Provider.of<AuthProvider>(context, listen: false).student?.email;
      if (email != null) {
        _emailController.text = email;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.appBgColor,
        appBar: CustomAppBar(
          title: AppLocalizations.of(context)!.security_title,
        ),
        body: Consumer<AuthProvider>(builder: (context, authProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.update_email,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColor.mainColor,
                  ),
                ),
                const SizedBox(height: 16),
                Form(
                  key: _emailFormKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText:
                              AppLocalizations.of(context)!.new_email_hint,
                          prefixIcon:
                              Icon(Icons.email, color: AppColor.textColor),
                          filled: true,
                          fillColor: AppColor.textBoxColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)!.email_required;
                          }
                          if (!value.contains('@')) {
                            return AppLocalizations.of(context)!.email_invalid;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      GradientButton(
                        text: _isLoadingEmail
                            ? AppLocalizations.of(context)!.loading
                            : AppLocalizations.of(context)!.update_email,
                        variant: 'primary',
                        disabled: _isLoadingEmail,
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialogFb1(
                                      title: AppLocalizations.of(context)!
                                          .are_you_sure,
                                      description: AppLocalizations.of(context)!
                                          .you_will_have_to_verify_account_again_and_no_access_to_courses,
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                                AppLocalizations.of(context)!
                                                    .cancel)),
                                        TextButton(
                                            onPressed: _updateEmail,
                                            child: Text(
                                                AppLocalizations.of(context)!
                                                    .confirm))
                                      ]));
                        },
                        color: AppColor.primary,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  AppLocalizations.of(context)!.update_password,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColor.mainColor,
                  ),
                ),
                const SizedBox(height: 16),
                Form(
                  key: _passwordFormKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _newPasswordController,
                        decoration: InputDecoration(
                          hintText:
                              AppLocalizations.of(context)!.new_password_hint,
                          prefixIcon:
                              Icon(Icons.lock, color: AppColor.textColor),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isNewPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: AppColor.textColor,
                            ),
                            onPressed: () {
                              setState(() {
                                _isNewPasswordVisible = !_isNewPasswordVisible;
                              });
                            },
                          ),
                          filled: true,
                          fillColor: AppColor.textBoxColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        obscureText: !_isNewPasswordVisible,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)!
                                .new_password_required;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _confirmPasswordController,
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!
                              .confirm_password_hint,
                          prefixIcon:
                              Icon(Icons.lock, color: AppColor.textColor),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isConfirmPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: AppColor.textColor,
                            ),
                            onPressed: () {
                              setState(() {
                                _isConfirmPasswordVisible =
                                    !_isConfirmPasswordVisible;
                              });
                            },
                          ),
                          filled: true,
                          fillColor: AppColor.textBoxColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        obscureText: !_isConfirmPasswordVisible,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)!
                                .confirm_password_required;
                          }
                          if (value != _newPasswordController.text) {
                            return AppLocalizations.of(context)!
                                .passwords_do_not_match;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      GradientButton(
                        text: _isLoadingPassword
                            ? AppLocalizations.of(context)!.loading
                            : AppLocalizations.of(context)!.update_password,
                        variant: 'primary',
                        disabled: _isLoadingPassword,
                        onTap: _updatePassword,
                        color: AppColor.primary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
