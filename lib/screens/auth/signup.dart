import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
  final _confirmPasswordController = TextEditingController();
  String? _firstNameError;
  String? _lastNameError;
  String? _firstNameArError;
  String? _lastNameArError;
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

  bool _validateCurrentStep() {
    // Create a map of form fields for each step
    final stepFields = {
      0: [
        _firstNameController,
        _lastNameController,
        _firstNameArController,
        _lastNameArController
      ],
      1: [_emailController, _passwordController],
      2: [_addressController, _phoneController],
      3: [], // Dropdown fields handled separately
      4: [], // Profile photo is optional
    };

    // For step 3 (Location and Class), check dropdown values
    if (_currentStep == 3) {
      return _selectedWilaya != null && _selectedClass != null;
    }

    // For step 4 (Profile Photo), always return true as it's optional
    if (_currentStep == 4) {
      return true;
    }

    // For step 1 (Account Info), validate special rules (e.g., password length)
    if (_currentStep == 1) {
      final email = _emailController.text;
      final password = _passwordController.text;

      // Check if email and password are not empty
      if (email.isEmpty || password.isEmpty) {
        return false;
      }

      // Add custom password length validation
      if (password.length <= 6) {
        return false;
      }
    }

    // For other steps, check if all required fields are filled
    final currentStepFields = stepFields[_currentStep] ?? [];
    return currentStepFields.every((controller) => controller.text.isNotEmpty);
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
        title: Text(AppLocalizations.of(context)!.personal_info, style: TextStyle(fontSize: 19,)),
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
              validator: (value) {
                // Regular Expression to match Arabic characters
                final arabicRegex = RegExp(r'^[\u0600-\u06FF\s]+$');

                if (value == null || value.isEmpty) {
                  return 'This field is required'; // Replace with localization if needed
                } else if (!arabicRegex.hasMatch(value)) {
                  return 'Please enter text in Arabic'; // Replace with localization
                }
                return null;
              },
            ),
          ],
        ),
      ),
      Step(
        state: _currentStep > 1 ? StepState.complete : StepState.indexed,
        isActive: _currentStep >= 1,
        title: Text(AppLocalizations.of(context)!.account_info, style: TextStyle(fontSize: 19,)),
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
        title: Text(AppLocalizations.of(context)!.contact_info, style: TextStyle(fontSize: 19,)),
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
        title: Text(AppLocalizations.of(context)!.location_class, style: TextStyle(fontSize: 19,)),
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
        title: Text(AppLocalizations.of(context)!.profile_photo, style: TextStyle(fontSize: 19,)),
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

  void _updateStepValidation() {
    setState(() {}); // Triggers UI rebuild to recheck button state
  }

  @override
  void initState() {
    super.initState();

    // Add listeners to all controllers involved in validation
    _firstNameController.addListener(_updateStepValidation);
    _lastNameController.addListener(_updateStepValidation);
    _firstNameArController.addListener(_updateStepValidation);
    _lastNameArController.addListener(_updateStepValidation);
    _emailController.addListener(_updateStepValidation);
    _passwordController.addListener(_updateStepValidation);
    _confirmPasswordController.addListener(_updateStepValidation);
    _addressController.addListener(_updateStepValidation);
    _phoneController.addListener(_updateStepValidation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBgColor,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Center(
                child: SvgPicture.asset(
                  'assets/icons/logo-v2-gradient.svg',
                  // height: 80,
                  width: 100,
                )
              ),
              Center(
                child: Image.asset(
                  'assets/icons/logo-large.png',
                  // height: 80,
                  width: 200,
                  color: AppColor.darkBackground,
                )
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Text(AppLocalizations.of(context)!.signup_subtitle,
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Stepper(
                  connectorColor: WidgetStatePropertyAll(AppColor.primary),
                  stepIconWidth: 50,
                  stepIconHeight: 50,
                  type: StepperType.vertical,
                  currentStep: _currentStep,
                  steps: getSteps(),
                  onStepContinue: () {
                    final isLastStep = _currentStep == getSteps().length - 1;

                    if (!_validateCurrentStep()) {
                      SnackBarHelper.showErrorSnackBar(context,
                          AppLocalizations.of(context)!.please_fill_all_fields);
                      return;
                    }

                    if (isLastStep) {
                      // Call the signup function
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
                    final isStepValid = _validateCurrentStep();

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        children: [
                          if (_currentStep > 0)
                            Expanded(
                              child: GradientButton(
                                text: AppLocalizations.of(context)!.back,
                                variant: 'blueGradient',
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
                              variant: 'blueGradient',
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
