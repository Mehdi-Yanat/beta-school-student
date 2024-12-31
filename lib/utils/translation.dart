import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TranslationHelper {
  static String getTranslatedClass(BuildContext context, String? classKey) {
    if (classKey == null) return AppLocalizations.of(context)!.not_specified;

    switch (classKey.toUpperCase()) {
      case 'PRIMARY_1':
        return AppLocalizations.of(context)!.class_PRIMARY_1;
      case 'PRIMARY_2':
        return AppLocalizations.of(context)!.class_PRIMARY_2;
      case 'PRIMARY_3':
        return AppLocalizations.of(context)!.class_PRIMARY_3;
      case 'PRIMARY_4':
        return AppLocalizations.of(context)!.class_PRIMARY_4;
      case 'PRIMARY_5':
        return AppLocalizations.of(context)!.class_PRIMARY_5;
      case 'MIDDLE_1':
        return AppLocalizations.of(context)!.class_MIDDLE_1;
      case 'MIDDLE_2':
        return AppLocalizations.of(context)!.class_MIDDLE_2;
      case 'MIDDLE_3':
        return AppLocalizations.of(context)!.class_MIDDLE_3;
      case 'MIDDLE_4':
        return AppLocalizations.of(context)!.class_MIDDLE_4;
      case 'SECONDARY_1':
        return AppLocalizations.of(context)!.class_SECONDARY_1;
      case 'SECONDARY_2':
        return AppLocalizations.of(context)!.class_SECONDARY_2;
      case 'SECONDARY_3':
        return AppLocalizations.of(context)!.class_SECONDARY_3;
      case 'OTHER':
        return AppLocalizations.of(context)!.class_OTHER;
      default:
        return AppLocalizations.of(context)!.not_specified;
    }
  }

  static String getTranslatedWilaya(BuildContext context, String? wilayaKey) {
    if (wilayaKey == null) return AppLocalizations.of(context)!.not_specified;

    switch (wilayaKey.toUpperCase()) {
      case 'ADRAR':
        return AppLocalizations.of(context)!.wilaya_ADRAR;
      case 'AIN_DEFLA':
        return AppLocalizations.of(context)!.wilaya_AIN_DEFLA;
      case 'AIN_TEMOUCHENT':
        return AppLocalizations.of(context)!.wilaya_AIN_TEMOUCHENT;
      case 'ALGIERS':
        return AppLocalizations.of(context)!.wilaya_ALGIERS;
      case 'ANNABA':
        return AppLocalizations.of(context)!.wilaya_ANNABA;
      case 'BATNA':
        return AppLocalizations.of(context)!.wilaya_BATNA;
      case 'BECHAR':
        return AppLocalizations.of(context)!.wilaya_BECHAR;
      case 'BEJAIA':
        return AppLocalizations.of(context)!.wilaya_BEJAIA;
      case 'BISKRA':
        return AppLocalizations.of(context)!.wilaya_BISKRA;
      case 'BLIDA':
        return AppLocalizations.of(context)!.wilaya_BLIDA;
      case 'BORDJ_BADJI_MOKHTAR':
        return AppLocalizations.of(context)!.wilaya_BORDJ_BADJI_MOKHTAR;
      case 'BORDJ_BOU_ARRERIDJ':
        return AppLocalizations.of(context)!.wilaya_BORDJ_BOU_ARRERIDJ;
      case 'BOUIRA':
        return AppLocalizations.of(context)!.wilaya_BOUIRA;
      case 'BOUMERDES':
        return AppLocalizations.of(context)!.wilaya_BOUMERDES;
      case 'CHLEF':
        return AppLocalizations.of(context)!.wilaya_CHLEF;
      case 'CONSTANTINE':
        return AppLocalizations.of(context)!.wilaya_CONSTANTINE;
      case 'DJELFA':
        return AppLocalizations.of(context)!.wilaya_DJELFA;
      case 'DJANET':
        return AppLocalizations.of(context)!.wilaya_DJANET;
      case 'EL_BAYADH':
        return AppLocalizations.of(context)!.wilaya_EL_BAYADH;
      case 'EL_MENIAA':
        return AppLocalizations.of(context)!.wilaya_EL_MENIAA;
      case 'EL_MGHAIER':
        return AppLocalizations.of(context)!.wilaya_EL_MGHAIER;
      case 'EL_OUED':
        return AppLocalizations.of(context)!.wilaya_EL_OUED;
      case 'EL_TARF':
        return AppLocalizations.of(context)!.wilaya_EL_TARF;
      case 'GHARDAIA':
        return AppLocalizations.of(context)!.wilaya_GHARDAIA;
      case 'GUELMA':
        return AppLocalizations.of(context)!.wilaya_GUELMA;
      case 'ILLIZI':
        return AppLocalizations.of(context)!.wilaya_ILLIZI;
      case 'IN_GUEZZAM':
        return AppLocalizations.of(context)!.wilaya_IN_GUEZZAM;
      case 'IN_SALAH':
        return AppLocalizations.of(context)!.wilaya_IN_SALAH;
      case 'JIJEL':
        return AppLocalizations.of(context)!.wilaya_JIJEL;
      case 'KHENCHELA':
        return AppLocalizations.of(context)!.wilaya_KHENCHLA;
      case 'LAGHOUAT':
        return AppLocalizations.of(context)!.wilaya_LAGHOUAT;
      case 'MASCARA':
        return AppLocalizations.of(context)!.wilaya_MASCARA;
      case 'MEDEA':
        return AppLocalizations.of(context)!.wilaya_MEDEA;
      case 'MILA':
        return AppLocalizations.of(context)!.wilaya_MILA;
      case 'MOSTAGANEM':
        return AppLocalizations.of(context)!.wilaya_MOSTAGANEM;
      case 'MSILA':
        return AppLocalizations.of(context)!.wilaya_MSILA;
      case 'NAAMA':
        return AppLocalizations.of(context)!.wilaya_NAAMA;
      case 'ORAN':
        return AppLocalizations.of(context)!.wilaya_ORAN;
      case 'OUARGLA':
        return AppLocalizations.of(context)!.wilaya_OUARGLA;
      case 'OUED_EL_BABRIT':
        return AppLocalizations.of(context)!.wilaya_OUED_EL_BABRIT;
      case 'OUM_EL_BOUAGHI':
        return AppLocalizations.of(context)!.wilaya_OUM_EL_BOUAGHI;
      case 'RELIZANE':
        return AppLocalizations.of(context)!.wilaya_RELIZANE;
      case 'SAIDA':
        return AppLocalizations.of(context)!.wilaya_SAIDA;
      case 'SETIF':
        return AppLocalizations.of(context)!.wilaya_SETIF;
      case 'SIDI_BEL_ABBES':
        return AppLocalizations.of(context)!.wilaya_SIDI_BEL_ABBES;
      case 'SKIKDA':
        return AppLocalizations.of(context)!.wilaya_SKIKDA;
      case 'SOUK_AHRAS':
        return AppLocalizations.of(context)!.wilaya_SOUK_AHRAS;
      case 'TAMANRASSET':
        return AppLocalizations.of(context)!.wilaya_TAMANRASSET;
      case 'TEBESSA':
        return AppLocalizations.of(context)!.wilaya_TEBESSA;
      case 'TIARET':
        return AppLocalizations.of(context)!.wilaya_TIARET;
      case 'TIMIMOUN':
        return AppLocalizations.of(context)!.wilaya_TIMIMOUN;
      case 'TINDOUF':
        return AppLocalizations.of(context)!.wilaya_TINDOUF;
      case 'TIPAZA':
        return AppLocalizations.of(context)!.wilaya_TIPAZA;
      case 'TISSEMSILT':
        return AppLocalizations.of(context)!.wilaya_TISSEMSILT;
      case 'TIZI_OUZOU':
        return AppLocalizations.of(context)!.wilaya_TIZI_OUZOU;
      case 'TLEMCEN':
        return AppLocalizations.of(context)!.wilaya_TLEMCEN;
      case 'TOUGGOURT':
        return AppLocalizations.of(context)!.wilaya_TOUGGOURT;
      case 'KHENCHLA':
        return AppLocalizations.of(context)!.wilaya_KHENCHLA;
      default:
        return wilayaKey;
    }
  }

  static String getTranslatedBranch(BuildContext context, String? branchKey) {
    if (branchKey == null) return AppLocalizations.of(context)!.not_specified;

    switch (branchKey.toUpperCase()) {
      case 'PRIMARY_GENERAL':
        return AppLocalizations.of(context)!.branch_PRIMARY_GENERAL;
      case 'MIDDLE_GENERAL':
        return AppLocalizations.of(context)!.branch_MIDDLE_GENERAL;
      case 'SECONDARY_SCIENCE':
        return AppLocalizations.of(context)!.branch_SECONDARY_SCIENCE;
      case 'SECONDARY_ARTS':
        return AppLocalizations.of(context)!.branch_SECONDARY_ARTS;
      case 'SECONDARY_LITERATURE':
        return AppLocalizations.of(context)!.branch_SECONDARY_LITERATURE;
      case 'SECONDARY_MATHEMATICS':
        return AppLocalizations.of(context)!.branch_SECONDARY_MATHEMATICS;
      case 'SECONDARY_TECHNIQUE_MATH':
        return AppLocalizations.of(context)!.branch_SECONDARY_TECHNIQUE_MATH;
      case 'SECONDARY_MANAGEMENT_ECONOMIES':
        return AppLocalizations.of(context)!
            .branch_SECONDARY_MANAGEMENT_ECONOMIES;
      case 'ALL_BRANCHES':
        return AppLocalizations.of(context)!.branch_ALL_BRANCHES;
      default:
        return AppLocalizations.of(context)!.not_specified;
    }
  }

  static String getTranslatedStatus(
      AppLocalizations localization, String status) {
    switch (status) {
      case 'PENDING':
        return localization.transaction_status_pending; // Translated "Pending"
      case 'FAILED':
        return localization.transaction_status_failed; // Translated "Failed"
      case 'PAID':
        return localization.transaction_status_paid; // Translated "Paid"
      default:
        return status; // Fallback to original status if no match
    }
  }

  static String getTranslatedLevel(BuildContext context, String? levelKey) {
    if (levelKey == null) return AppLocalizations.of(context)!.not_specified;

    switch (levelKey.toUpperCase()) {
      case 'BEGINNER':
        return AppLocalizations.of(context)!.level_beginner;
      case 'INTERMEDIATE':
        return AppLocalizations.of(context)!.level_intermediate;
      case 'ADVANCED':
        return AppLocalizations.of(context)!.level_advanced;
      default:
        return AppLocalizations.of(context)!.not_specified;
    }
  }

  // Helper method to format enum values for display
  static String formatEnumValue(String value) {
    return value
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }

  static String getTranslatedSubject(BuildContext context, String? subjectKey) {
    if (subjectKey == null) return AppLocalizations.of(context)!.not_specified;

    switch (subjectKey.toUpperCase()) {
      case 'MATHEMATICS':
        return AppLocalizations.of(context)!.subject_MATHEMATICS;
      case 'SCIENCE':
        return AppLocalizations.of(context)!.subject_SCIENCE;
      case 'PHYSICS':
        return AppLocalizations.of(context)!.subject_PHYSICS;
      case 'HISTORY_GEOGRAPHY':
        return AppLocalizations.of(context)!.subject_HISTORY_GEOGRAPHY;
      case 'ISLAMIC_STUDIES':
        return AppLocalizations.of(context)!.subject_ISLAMIC_STUDIES;
      case 'ARABIC':
        return AppLocalizations.of(context)!.subject_ARABIC;
      case 'FRENCH':
        return AppLocalizations.of(context)!.subject_FRENCH;
      case 'ENGLISH':
        return AppLocalizations.of(context)!.subject_ENGLISH;
      case 'OTHER':
        return AppLocalizations.of(context)!.subject_OTHER;
      default:
        return AppLocalizations.of(context)!.not_specified;
    }
  }
}
