import 'package:flutter/material.dart';
import 'package:online_course/services/auth_service.dart';
import 'package:online_course/utils/translation.dart';
import 'package:online_course/widgets/snackbar.dart';
import '../../models/student.dart';
import '../../theme/color.dart';
import '../../utils/constant.dart';
import '../../widgets/gradient_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _firstNameArController = TextEditingController();
  final _lastNameArController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isPasswordVisible = false;
  
  File? _profileImage;
  final _picker = ImagePicker();

  String? _selectedWilaya;
  String? _selectedClass;
  bool _isLoading = false;
  int _currentStep = 0;

  final List<String> wilayas = Wilaya.values.map((e) => e.name).toList();
  final List<String> classes = Class.values.map((e) => e.name).toList();

  // Add image picker method
  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _profileImage = File(image.path);
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  void _signup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final student = Student(
          email: _emailController.text,
          password: _passwordController.text,
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          firstNameAr: _firstNameArController.text,
          lastNameAr: _lastNameArController.text,
          address: _addressController.text,
          phone: _phoneController.text,
          wilaya: _selectedWilaya!,
          studentClass: _selectedClass!,
          profilePic: _profileImage?.path);

      final locale = Localizations.localeOf(context).languageCode;

      final success = await AuthService.registerStudent(student, lang: locale);

      if (success) {
        if (mounted) {
          SnackBarHelper.showSuccessSnackBar(
              context, AppLocalizations.of(context)!.signup_success);
          Navigator.pushReplacementNamed(context, '/login');
        }
      } else {
        if (mounted) {
          SnackBarHelper.showErrorSnackBar(
              context, AppLocalizations.of(context)!.signup_failed);
        }
      }
    } catch (e) {
      if (mounted) {
        SnackBarHelper.showErrorSnackBar(context, e.toString());
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<Step> getSteps() {
    return [
      Step(
        state: _currentStep > 0 ? StepState.complete : StepState.indexed,
        isActive: _currentStep >= 0,
        title: Text(AppLocalizations.of(context)!.personal_info),
        content: Column(
          children: [
            TextFormField(
              controller: _firstNameController,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.first_name,
                prefixIcon: Icon(Icons.person, color: AppColor.textColor),
                filled: true,
                fillColor: AppColor.textBoxColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.first_name_required;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _lastNameController,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.last_name,
                prefixIcon:
                    Icon(Icons.person_outline, color: AppColor.textColor),
                filled: true,
                fillColor: AppColor.textBoxColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.last_name_required;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _firstNameArController,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.first_name_ar,
                prefixIcon: Icon(Icons.person, color: AppColor.textColor),
                filled: true,
                fillColor: AppColor.textBoxColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _lastNameArController,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.last_name_ar,
                prefixIcon:
                    Icon(Icons.person_outline, color: AppColor.textColor),
                filled: true,
                fillColor: AppColor.textBoxColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
      ),
      Step(
        state: _currentStep > 1 ? StepState.complete : StepState.indexed,
        isActive: _currentStep >= 1,
        title: Text(AppLocalizations.of(context)!.account_info),
        content: Column(
          children: [
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.email,
                prefixIcon: Icon(Icons.email, color: AppColor.textColor),
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
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.password,
                prefixIcon: Icon(Icons.lock, color: AppColor.textColor),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: AppColor.textColor,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
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
              obscureText: !_isPasswordVisible,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.password_required;
                }
                if (value.length < 6) {
                  return AppLocalizations.of(context)!.password_length;
                }
                return null;
              },
            ),
          ],
        ),
      ),
      Step(
        state: _currentStep > 2 ? StepState.complete : StepState.indexed,
        isActive: _currentStep >= 2,
        title: Text(AppLocalizations.of(context)!.contact_info),
        content: Column(
          children: [
            TextFormField(
              controller: _addressController,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.address,
                prefixIcon: Icon(Icons.home, color: AppColor.textColor),
                filled: true,
                fillColor: AppColor.textBoxColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.address_required;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.phone,
                prefixIcon: Icon(Icons.phone, color: AppColor.textColor),
                filled: true,
                fillColor: AppColor.textBoxColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.phone_required;
                }
                return null;
              },
            ),
          ],
        ),
      ),
      Step(
        state: _currentStep > 3 ? StepState.complete : StepState.indexed,
        isActive: _currentStep >= 3,
        title: Text(AppLocalizations.of(context)!.location_class),
        content: Column(
          children: [
            DropdownButtonFormField<String>(
              value: _selectedWilaya,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.select_wilaya,
                prefixIcon:
                    Icon(Icons.location_city, color: AppColor.textColor),
                filled: true,
                fillColor: AppColor.textBoxColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              items: wilayas.map((String wilaya) {
                return DropdownMenuItem(
                  value: wilaya,
                  child: Text(
                    TranslationHelper.getTranslatedWilaya(context, wilaya),
                    textDirection: TextDirection.rtl,
                  ),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  _selectedWilaya = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.wilaya_required;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedClass,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.select_class,
                prefixIcon: Icon(Icons.school, color: AppColor.textColor),
                filled: true,
                fillColor: AppColor.textBoxColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              items: classes.map((String classItem) {
                return DropdownMenuItem(
                  value: classItem,
                  child: Text(
                    TranslationHelper.getTranslatedClass(context, classItem),
                    textDirection: TextDirection.rtl,
                  ),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  _selectedClass = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.class_required;
                }
                return null;
              },
            ),
          ],
        ),
      ),
      Step(
        state: _currentStep > 4 ? StepState.complete : StepState.indexed,
        isActive: _currentStep >= 4,
        title: Text(AppLocalizations.of(context)!.profile_photo),
        content: Column(
          children: [
            if (_profileImage != null)
              Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      _profileImage!,
                      height: 200,
                      width: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      icon: Icon(Icons.close, color: Colors.red),
                      onPressed: () => setState(() => _profileImage = null),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 16),
            GradientButton(
              text: _profileImage == null
                  ? AppLocalizations.of(context)!.upload_photo
                  : AppLocalizations.of(context)!.change_photo,
              variant: 'secondary',
              onTap: _pickImage,
              color: AppColor.primary,
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.photo_optional,
              style: TextStyle(
                color: AppColor.textColor.withValues(alpha: 0.7),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBgColor,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              Center(
                child: Image.asset(
                  'assets/logo.png',
                  height: 80,
                  color: AppColor.primary,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Stepper(
                  type: StepperType.vertical,
                  currentStep: _currentStep,
                  steps: getSteps(),
                  onStepContinue: () {
                    final isLastStep = _currentStep == getSteps().length - 1;
                    if (isLastStep) {
                      _signup();
                    } else {
                      setState(() {
                        _currentStep += 1;
                      });
                    }
                  },
                  onStepCancel: _currentStep == 0
                      ? null
                      : () {
                          setState(() {
                            _currentStep -= 1;
                          });
                        },
                  controlsBuilder: (context, details) {
                    final isLastStep = _currentStep == getSteps().length - 1;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        children: [
                          if (_currentStep > 0)
                            Expanded(
                              child: GradientButton(
                                text: AppLocalizations.of(context)!.back,
                                variant: 'secondary',
                                onTap: details.onStepCancel!,
                                color: AppColor.primary,
                              ),
                            ),
                          if (_currentStep > 0) const SizedBox(width: 12),
                          Expanded(
                            child: GradientButton(
                              text: isLastStep
                                  ? (_isLoading
                                      ? AppLocalizations.of(context)!.loading
                                      : AppLocalizations.of(context)!
                                          .signup_button)
                                  : AppLocalizations.of(context)!.next,
                              variant: 'primary',
                              disabled: _isLoading,
                              onTap: details.onStepContinue!,
                              color: AppColor.primary,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.already_have_account,
                      style: TextStyle(color: AppColor.textColor),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/login'),
                      child: Text(
                        AppLocalizations.of(context)!.login_button,
                        style: TextStyle(color: AppColor.primary),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _firstNameArController.dispose();
    _lastNameArController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
