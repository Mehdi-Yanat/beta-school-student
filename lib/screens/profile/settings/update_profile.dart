import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:online_course/models/student.dart';
import 'package:online_course/providers/auth_provider.dart';
import 'package:online_course/services/auth_service.dart';
import 'package:online_course/theme/color.dart';
import 'package:online_course/utils/constant.dart';
import 'package:online_course/utils/storage.dart';
import 'package:online_course/utils/translation.dart';
import 'package:online_course/widgets/appbar.dart';
import 'package:online_course/widgets/gradient_button.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({Key? key}) : super(key: key);

  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _firstNameArController = TextEditingController();
  final _lastNameArController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();

  String? _selectedWilaya;
  String? _selectedClass;
  File? _newProfileImage;
  bool _isLoading = false;
  String _errorMessage = '';

  final List<String> wilayas = Wilaya.values.map((e) => e.name).toList();
  final List<String> classes = Class.values.map((e) => e.name).toList();

  @override
  void initState() {
    super.initState();
    _loadCurrentUserData();
  }

  void _loadCurrentUserData() {
    try {
      final student = context.read<AuthProvider>().student;
      if (student != null) {
        _firstNameController.text = student.firstName;
        _lastNameController.text = student.lastName;
        _firstNameArController.text = student.firstNameAr ?? '';
        _lastNameArController.text = student.lastNameAr ?? '';
        _addressController.text = student.address ?? '';
        _phoneController.text = student.phone ?? '';

        // Reset dropdowns first
        setState(() {
          _selectedWilaya = null;
          _selectedClass = null;
        });

        // Verify values exist in lists before setting
        if (wilayas.contains(student.wilaya)) {
          setState(() => _selectedWilaya = student.wilaya);
        }

        if (classes.contains(student.studentClass)) {
          setState(() => _selectedClass = student.studentClass);
        }
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() => _newProfileImage = File(image.path));
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final authProvider = context.read<AuthProvider>();
      final token = await StorageService.getToken("accessToken");

      if (token == null) {
        throw Exception('No auth token found');
      }

      final updatedStudent = Student(
        email: authProvider.student!.email,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        firstNameAr: _firstNameArController.text,
        lastNameAr: _lastNameArController.text,
        address: _addressController.text,
        phone: _phoneController.text,
        wilaya: _selectedWilaya!,
        studentClass: _selectedClass!,
      );

      final result = await AuthService.updateProfile(
        token,
        updatedStudent,
        newProfilePic: _newProfileImage,
      );

      if (result.success) {
        await authProvider.refreshProfile();
      } else {
        setState(() => _errorMessage = result.message);
      }
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Update dropdown widgets
  Widget _buildWilayaDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedWilaya,
      decoration: InputDecoration(
        hintText: AppLocalizations.of(context)!.select_wilaya,
        prefixIcon: Icon(Icons.location_city, color: AppColor.textColor),
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
        setState(() => _selectedWilaya = value);
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return AppLocalizations.of(context)!.wilaya_required;
        }
        return null;
      },
    );
  }

  Widget _buildClassDropdown() {
    return DropdownButtonFormField<String>(
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
        setState(() => _selectedClass = value);
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return AppLocalizations.of(context)!.class_required;
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.update_profile,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Profile Image Section
              Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: _newProfileImage != null
                        ? FileImage(_newProfileImage!)
                        : null,
                    child: _newProfileImage == null
                        ? Icon(Icons.person, size: 50)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: IconButton(
                      icon: Icon(Icons.camera_alt),
                      onPressed: _pickImage,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Form Fields
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
              ),
              const SizedBox(height: 16),

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
              ),
              const SizedBox(height: 16),

              _buildWilayaDropdown(),
              const SizedBox(height: 16),
              _buildClassDropdown(),
              const SizedBox(height: 16),

              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    _errorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
                ),

              GradientButton(
                text: _isLoading
                    ? AppLocalizations.of(context)!.loading
                    : AppLocalizations.of(context)!.update,
                variant: 'primary',
                disabled: _isLoading,
                onTap: _updateProfile,
                color: AppColor.primary,
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
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
