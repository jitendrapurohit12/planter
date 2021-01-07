import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const kSharedToken = 'token';
const kSharedRefreshToken = 'refresh_token';
const kSharedName = 'name';

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

Future<void> clearPrefs() async {
  final prefs = await getPrefs();
  return prefs.clear();
}