import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:online_course/providers/course_provider.dart';
import 'package:online_course/theme/color.dart';
import 'package:online_course/utils/translation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FilterModal extends StatefulWidget {
  @override
  _FilterModalState createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal> {
  String? _selectedSubject;
  String? _selectedClass;
  String? _selectedBranch;

  @override
  void initState() {
    super.initState();
    final provider = context.read<CourseProvider>();
    _selectedSubject = provider.selectedSubject;
    _selectedClass = provider.selectedClass;
    _selectedBranch = provider.selectedBranch;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.filter_title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColor.darker,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          SizedBox(height: 16),

          // Subject Dropdown
          DropdownButtonFormField<String>(
            value: _selectedSubject,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.select_subject,
              border: OutlineInputBorder(),
            ),
            items: [
              'MATHEMATICS',
              'SCIENCE',
              'PHYSICS',
              'HISTORY_GEOGRAPHY',
              'ISLAMIC_STUDIES',
              'ARABIC',
              'FRENCH',
              'ENGLISH',
              'SPANISH',
              'GERMAN',
              'OTHER',
            ].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  TranslationHelper.getTranslatedSubject(context, value),
                ),
              );
            }).toList(),
            onChanged: (value) => setState(() => _selectedSubject = value),
          ),
          SizedBox(height: 16),

          // Class Dropdown
          DropdownButtonFormField<String>(
            value: _selectedClass,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.select_class,
              border: OutlineInputBorder(),
            ),
            items: [
              'PRIMARY_1',
              'PRIMARY_2',
              'PRIMARY_3',
              'PRIMARY_4',
              'PRIMARY_5',
              'MIDDLE_1',
              'MIDDLE_2',
              'MIDDLE_3',
              'MIDDLE_4',
              'SECONDARY_1',
              'SECONDARY_2',
              'SECONDARY_3',
            ].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  TranslationHelper.getTranslatedClass(context, value),
                ),
              );
            }).toList(),
            onChanged: (value) => setState(() => _selectedClass = value),
          ),
          SizedBox(height: 16),

          // Educational Branch Dropdown
          DropdownButtonFormField<String>(
            value: _selectedBranch,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.select_branch,
              border: OutlineInputBorder(),
            ),
            items: [
              'PRIMARY_GENERAL',
              'MIDDLE_GENERAL',
              'SECONDARY_SCIENCE',
              'SECONDARY_ARTS',
              'SECONDARY_LITERATURE',
              'SECONDARY_MATHEMATICS',
              'SECONDARY_TECHNIQUE_MATH',
              'SECONDARY_MANAGEMENT_ECONOMIES',
            ].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  TranslationHelper.getTranslatedBranch(context, value),
                ),
              );
            }).toList(),
            onChanged: (value) => setState(() => _selectedBranch = value),
          ),
          SizedBox(height: 24),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  child: Text(AppLocalizations.of(context)!.reset_filters),
                  onPressed: () {
                    setState(() {
                      _selectedSubject = null;
                      _selectedClass = null;
                      _selectedBranch = null;
                    });
                  },
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  child: Text(AppLocalizations.of(context)!.apply_filters),
                  onPressed: () {
                    context.read<CourseProvider>().setFilters(
                        subject: _selectedSubject,
                        teacherClass: _selectedClass,
                        educationalBranch: _selectedBranch,
                        context: context);
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
