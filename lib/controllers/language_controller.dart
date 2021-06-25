import 'package:flutter/material.dart';
import 'package:gmt_planter/constant/constant.dart';
import 'package:gmt_planter/helper/method_helper.dart';
import 'package:gmt_planter/prefs/shared_prefs.dart';

class LanguageNotifier extends ChangeNotifier {
  Locale _appLocale = kLocaleEn;

  Locale get appLocale => _appLocale;

  LanguageNotifier() {
    getLocale();
  }

  Future<void> getLocale() async {
    final langCode = await getLanguageCode();
    final countryCode = await getCountryCode();
    if (langCode != null && countryCode != null) {
      _appLocale = Locale(langCode, countryCode);
      notifyListeners();
    }
  }

  Future<void> fetchLocale() async {
    final languageSelected = await getLanguageCode();
    _appLocale = Locale(languageSelected);
  }

  Future<void> refresh() async {
    await zeroDelay();
    notifyListeners();
  }

  Future<void> changeLanguage(BuildContext context, Locale locale) async {
    if (_appLocale == locale) return;
    _appLocale = locale;
    final isArLocale = locale == kLocaleEn;
    final languageCode = isArLocale ? kLangEn : kLangIn;
    final countryCode = isArLocale ? kCountryEn : kCountryIn;
    await saveLanguageCode(value: languageCode);
    await saveCountryCode(value: countryCode);
    refresh();
  }
}
