import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gmt_planter/constant/constant.dart';
import 'package:gmt_planter/models/translation_model.dart';

class AppLocalizations {
  Locale locale;

  AppLocalizations(this.locale);

  // Helper method to keep the code in the widgets concise
  // Localizations are accessed using an InheritedWidget "of" syntax
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  // Static member to have a simple access to the delegate from the MaterialApp
  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  TranslationModel _translationModel;

  TranslationModel get model => _translationModel;

  Future<bool> load() async {
    final jsonString = await rootBundle.loadString('assets/language/${locale.languageCode}.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString) as Map<String, dynamic>;
    _translationModel = TranslationModel.fromJson(jsonMap);

    return true;
  }

  Future<void> reload({@required Locale locale}) async {
    this.locale = locale;

    load();
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  // This delegate instance will never change (it doesn't even have fields!)
  // It can provide a constant constructor.
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    // Include all of your supported language codes here
    return [kLangEn, kLangIn].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    // AppLocalizations class is where the JSON loading actually runs
    final AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
