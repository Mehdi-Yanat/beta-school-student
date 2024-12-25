import 'package:flutter_dotenv/flutter_dotenv.dart';

const int ANIMATED_BODY_MS = 500;

class ImageUrls {
  static final String baseUrl = dotenv.env['API_URL'] ?? '';

  static const String defaultAvatar = "assets/images/profile.png";
  static const String defaultCourse = "assets/images/default_course.png";

  static String getFullUrl(String? url) {
    if (url == null) return defaultAvatar;
    if (url.startsWith('https')) return url;
    if (url.startsWith('uploads')) {
      return "$baseUrl/$url".replaceAll(r'\\', '/');
    }
    if (url.startsWith('assets')) return url;
    return defaultAvatar;
  }

  static bool isNetworkUrl(String? url) {
    if (url == null) return false;
    return url.startsWith('https') ||
        url.startsWith('uploads') ||
        url.startsWith(baseUrl);
  }
}

enum Wilaya {
  ADRAR,
  CHLEF,
  LAGHOUAT,
  OUM_EL_BOUAGHI,
  BATNA,
  BEJAIA,
  BISKRA,
  BECHAR,
  BLIDA,
  BOUIRA,
  TAMANRASSET,
  TEBESSA,
  TLEMCEN,
  TIARET,
  TIZI_OUZOU,
  ALGIERS,
  DJELFA,
  JIJEL,
  SETIF,
  SAIDA,
  SKIKDA,
  SIDI_BEL_ABBES,
  ANNABA,
  GUELMA,
  CONSTANTINE,
  MEDEA,
  MOSTAGANEM,
  MSILA,
  MASCARA,
  OUARGLA,
  ORAN,
  EL_BAYADH,
  ILLIZI,
  BORDJ_BOU_ARRERIDJ,
  BOUMERDES,
  EL_TARF,
  TINDOUF,
  TISSEMSILT,
  EL_OUED,
  KHENCHLA,
  SOUK_AHRAS,
  TIPAZA,
  MILA,
  AIN_DEFLA,
  NAAMA,
  AIN_TEMOUCHENT,
  GHARDAIA,
  RELIZANE,
  TIMIMOUN,
  BORDJ_BADJI_MOKHTAR,
  OUED_EL_BABRIT,
  IN_GUEZZAM,
  TOUGGOURT,
  DJANET,
  IN_SALAH,
  EL_MGHAIER,
  EL_MENIAA
}

enum Class {
  PRIMARY_1,
  PRIMARY_2,
  PRIMARY_3,
  PRIMARY_4,
  PRIMARY_5,
  MIDDLE_1,
  MIDDLE_2,
  MIDDLE_3,
  MIDDLE_4,
  SECONDARY_1,
  SECONDARY_2,
  SECONDARY_3,
  OTHER
}

enum Subject {
  MATHEMATICS,
  SCIENCE,
  PHYSICS,
  HISTORY_GEOGRAPHY,
  ISLAMIC_STUDIES,
  ARABIC,
  FRENCH,
  ENGLISH,
  OTHER
}

enum EducationalBranch {
  // Primary Education
  PRIMARY_GENERAL,
  // Middle Education
  MIDDLE_GENERAL,
  // Secondary Education
  SECONDARY_SCIENCE,
  SECONDARY_ARTS,
  SECONDARY_LITERATURE,
  SECONDARY_MATHEMATICS,
  SECONDARY_TECHNIQUE_MATH,
  SECONDARY_MANAGEMENT_ECONOMIES,

  ALL_BRANCHES
}

enum CourseLevel { BEGINNER, INTERMEDIATE, ADVANCED }

enum CourseStatus { UNDER_CREATION, PENDING, ACCEPTED, TO_REVIEW, REJECT }
