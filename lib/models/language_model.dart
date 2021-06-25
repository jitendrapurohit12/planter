import 'dart:ui';

import 'package:gmt_planter/constant/constant.dart';

class LanguageModel {
  String title, path;
  Locale locale;

  LanguageModel(this.title, this.path, this.locale);
}

final languageList = [
  LanguageModel('English', kImageFlagEn, kLocaleEn),
  LanguageModel('Indonesian', kImageFlagId, kLocaleIn),
];
