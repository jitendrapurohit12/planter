import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const kSharedName = 'name';
const kSharedToken = 'token';
const kSharedCounter = 'counter';
const kSharedPassword = 'password';
const kSharedCountryCode = 'country_code';
const kSharedProfileImage = 'profile_image';
const kSharedRefreshToken = 'refresh_token';
const kSharedLanguageCode = 'language_code';

Future<SharedPreferences> getPrefs() async => SharedPreferences.getInstance();

Future<void> saveToken({
  @required String value,
}) async {
  final prefs = await getPrefs();
  prefs.setString(kSharedToken, value);
}

Future<String> getToken() async {
  final prefs = await getPrefs();
  return prefs.getString(kSharedToken);
}

Future<void> saveName({
  @required String value,
}) async {
  final prefs = await getPrefs();
  prefs.setString(kSharedName, value);
}

Future<String> getName() async {
  final prefs = await getPrefs();
  return prefs.getString(kSharedName);
}

Future<void> saveRefreshToken({
  @required String value,
}) async {
  final prefs = await getPrefs();
  prefs.setString(kSharedRefreshToken, value);
}

Future<String> getRefreshToken() async {
  final prefs = await getPrefs();
  return prefs.getString(kSharedRefreshToken);
}

Future<void> saveLanguageCode({@required String value}) async {
  final prefs = await getPrefs();
  prefs.setString(kSharedLanguageCode, value);
}

Future<String> getLanguageCode() async {
  final prefs = await getPrefs();
  return prefs.getString(kSharedLanguageCode);
}

Future<void> saveCountryCode({@required String value}) async {
  final prefs = await getPrefs();
  prefs.setString(kSharedCountryCode, value);
}

Future<String> getCountryCode() async {
  final prefs = await getPrefs();
  return prefs.getString(kSharedCountryCode);
}

Future<void> savePassword({@required String value}) async {
  final prefs = await getPrefs();
  prefs.setString(kSharedPassword, value);
}

Future<String> getPassword() async {
  final prefs = await getPrefs();
  return prefs.getString(kSharedPassword);
}

Future<void> saveProfileImage({@required String value}) async {
  final prefs = await getPrefs();
  prefs.setString(kSharedProfileImage, value);
}

Future<String> getProfileImage() async {
  final prefs = await getPrefs();
  return prefs.getString(kSharedProfileImage);
}

Future<void> saveStoryCounter({@required int value}) async {
  final prefs = await getPrefs();
  prefs.setInt(kSharedCounter, value);
}

Future<int> getStoryCounter() async {
  final prefs = await getPrefs();
  return prefs.getInt(kSharedCounter) ?? 0;
}

Future<void> clearPrefs() async {
  final prefs = await getPrefs();
  return prefs.clear();
}
