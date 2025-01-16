import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:online_course/providers/auth_provider.dart';
import 'package:online_course/services/auth_service.dart';
import 'package:online_course/utils/translation.dart';
import 'package:online_course/widgets/snackbar.dart';

import '../../models/student.dart';
import '../../theme/color.dart';
import '../../utils/constant.dart';
import '../../widgets/FloatingActionButton.dart';
import '../../widgets/gradient_button.dart';

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
  String? _firstNameError;
  String? _lastNameError;
  String? _firstNameArError;
  String? _lastNameArError;
  String? _emailError;
  String? _passwordError;
  String? _phoneError;
  bool _isPasswordVisible = false;
  AuthProvider authProvider = AuthProvider();

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
    if (_currentStep == 0) {
      return _firstNameError == null &&
          _lastNameError == null &&
          _firstNameArError == null &&
          _lastNameArError == null;
    }

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
      return _emailError == null && _passwordError == null;
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

      final signup = await AuthService.registerStudent(student, lang: locale);

      if (signup.success) {
        await authProvider.initAuth();
        if (mounted) {
          SnackBarHelper.showSuccessSnackBar(
              context, AppLocalizations.of(context)!.signup_success);
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/root',
                (Route<dynamic> route) => false,
          );
        }
      } else {
        if (mounted) {
          SnackBarHelper.showErrorSnackBar(
              context, signup.message);
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
        title: Text(AppLocalizations.of(context)!.personal_info,
            style: TextStyle(
              fontSize: 19,
            )),
        content: Column(
          children: [
            TextFormField(
              controller: _firstNameController,
              decoration: InputDecoration(
                errorText: _firstNameError,
                hintText: AppLocalizations.of(context)!.first_name,
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
              controller: _lastNameController,
              decoration: InputDecoration(
                errorText: _lastNameError,
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
                errorText: _firstNameArError,
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
                errorText: _lastNameArError,
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
        title: Text(AppLocalizations.of(context)!.account_info,
            style: TextStyle(
              fontSize: 19,
            )),
        content: Column(
          children: [
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                errorText: _emailError,
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
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                errorText: _passwordError,
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
            ),
          ],
        ),
      ),
      Step(
        state: _currentStep > 2 ? StepState.complete : StepState.indexed,
        isActive: _currentStep >= 2,
        title: Text(AppLocalizations.of(context)!.contact_info,
            style: TextStyle(
              fontSize: 19,
            )),
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
                errorText: _phoneError,
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
        title: Text(AppLocalizations.of(context)!.location_class,
            style: TextStyle(
              fontSize: 19,
            )),
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
        title: Text(AppLocalizations.of(context)!.profile_photo,
            style: TextStyle(
              fontSize: 19,
            )),
        content: Column(
          children: [
            if (_profileImage == null)
              Text(
                AppLocalizations.of(context)!.profile_photo_not_necessary,
              ),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Expanded(
                //   child: GradientButton(
                //     text: AppLocalizations.of(context)!.take_photo,
                //     variant: 'secondary',
                //     onTap: _takePhoto, // Call the new method for taking a photo
                //     color: AppColor.primary,
                //   ),
                // ),
                FloatingActionButtonFb3(
                    icon: Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.white,
                    ),
                    color: AppColor.primary,
                    tag: 'btn1',
                    onPressed: _takePhoto),
                const SizedBox(width: 8),
                // Text(
                //   text: _profileImage == null
                //       ? AppLocalizations.of(context)!.upload_photo
                //       : AppLocalizations.of(context)!.change_photo,
                //   variant: 'secondary',
                //   onTap: _pickImage,
                //   color: AppColor.primary,
                // ),
                FloatingActionButtonFb3(
                    icon: Icon(
                      Icons.file_download_rounded,
                      color: Colors.white,
                    ),
                    color: AppColor.primary,
                    tag: 'btn2',
                    onPressed: _pickImage)
              ],
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    ];
  }


  // Method to take a photo using the camera
  Future<void> _takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        setState(() {
          _profileImage = File(photo.path);
        });
      }
    } catch (e) {
      print('Error taking photo: $e');
    }
  }

  @override
  void initState() {
    super.initState();

    // // Add listeners to all controllers involved in validation_firstNameController.addListener(_updateStepValidation);
    // _lastNameController.addListener(_updateStepValidation);
    // _firstNameArController.addListener(_updateStepValidation);
    // _lastNameArController.addListener(_updateStepValidation);
    // _emailController.addListener(_updateStepValidation);
    // _passwordController.addListener(_updateStepValidation);
    // _confirmPasswordController.addListener(_updateStepValidation);
    // _addressController.addListener(_updateStepValidation);
    // _phoneController.addListener(_updateStepValidation);

    _firstNameController.addListener(() {
      setState(() {
        _firstNameError = _validateFirstName(_firstNameController.text);
        _firstNameError = _validateNameInLatinChars(_firstNameController.text);
      });
    });
    _lastNameController.addListener(() {
      setState(() {
        _lastNameError = _validateLastName(_lastNameController.text);
        _lastNameError = _validateNameInLatinChars(_lastNameController.text);
      });
    });
    _firstNameArController.addListener(() {
      setState(() {
        _firstNameArError = _validateFirstName(_firstNameArController.text);
        _firstNameArError =
            _validateNameInArabicChars(_firstNameArController.text);
      });
    });
    _lastNameArController.addListener(() {
      setState(() {
        _lastNameArError = _validateLastName(_lastNameArController.text);
        _lastNameArError =
            _validateNameInArabicChars(_lastNameArController.text);
      });
    });
    _emailController.addListener(() {
      setState(() {
        _emailError = _validateEmail(_emailController.text);
      });
    });
    _passwordController.addListener(() {
      setState(() {
        _passwordError = _validatePassword(_passwordController.text);
      });
    });
    _phoneController.addListener(() {
      setState(() {
        _phoneError = _validatePhoneNumber(_phoneController.text);
      });
    });
  }

  String? _validatePhoneNumber(String value) {
    if (value.isEmpty) {
      return AppLocalizations.of(context)!.phone_required;
    }
    if (!RegExp(r'^(0|(\+213))?[5-7][0-9]{8}$').hasMatch(value)) {
      return AppLocalizations.of(context)!.invalid_algerian_phone_number;
    }
    return null;
  }

  String? _validateFirstName(String value) {
    if (value.isEmpty) {
      return AppLocalizations.of(context)!.first_name_required;
    }
    return null;
  }

  String? _validateEmail(String value) {
    if (value.isEmpty) {
      return AppLocalizations.of(context)!.email_required;
    }
    if (!RegExp(r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$')
        .hasMatch(value)) {
      return AppLocalizations.of(context)!.invalid_email_format;
    }
    return null;
  }

  String? _validatePassword(String value) {
    if (value.length < 8) {
      return AppLocalizations.of(context)!.password_must_be_longer_than_8_chars;
    }
    if (!RegExp(r'[A-Za-z]').hasMatch(value)) {
      return AppLocalizations.of(context)!.password_must_contain_letters;
    }
    if (!RegExp(r'\d').hasMatch(value)) {
      return AppLocalizations.of(context)!.password_must_contain_numbers;
    }
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return AppLocalizations.of(context)!.password_must_contain_special_chars;
    }
    return null;
  }

  String? _validateLastName(String value) {
    if (value.isEmpty) {
      return AppLocalizations.of(context)!.last_name_required;
    }
    return null;
  }

  String? _validateNameInLatinChars(String value) {
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return AppLocalizations.of(context)!.name_must_be_in_latin_char;
    }
    return null;
  }

  String? _validateNameInArabicChars(String value) {
    if (!RegExp(r'^[\u0621-\u064A\s]+$').hasMatch(value)) {
      return AppLocalizations.of(context)!.name_must_be_in_arabic_char;
    }
    return null;
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
              )),
              Center(
                  child: Image.asset(
                'assets/icons/logo-large.png',
                // height: 80,
                width: 200,
                color: AppColor.darkBackground,
              )),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Text(
                  AppLocalizations.of(context)!.signup_subtitle,
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Stepper(
                  connectorColor: WidgetStatePropertyAll(AppColor.primary),
                  stepIconWidth: 25,
                  stepIconHeight: 25,
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
                              disabled: _isLoading || !isStepValid,
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
