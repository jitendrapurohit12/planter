import 'package:flutter/material.dart';
import 'package:gmt_planter/constant/constant.dart';

String notNullValidator(String key, String value) =>
    value == null || value.trim().isEmpty ? errorGeneric(key) : null;

String emailValidator(String key, String value) =>
    RegExp(kRegexEmail).hasMatch(value) ? null : errorGeneric(key);

String notMandatoryEmailValidator(String key, String value) =>
    (value.isEmpty || RegExp(kRegexEmail).hasMatch(value))
        ? null
        : errorGeneric(key);

String passwordValidator(String key, String value) =>
    value.trim().isNotEmpty && value.length >= 6
        ? null
        : errorInvalidPassword(key);

String errorGeneric(String key) => 'enter a valid $key!';
String errorInvalidPhoneNumber(String key) => 'enter a valid 10 digit $key!';
String errorInvalidPassword(String key) => 'enter a valid 6 digit $key!';
String errorPasswordMisMatch = "'Password' and 'Confirm Password' don't match!";

String getValidatorBasedOnInputType({
  @required TextInputType type,
  @required String key,
  @required String value,
  bool isMandatory = true,
}) {
  assert(value != null);
  assert(key != null);
  if (isMandatory || value.isNotEmpty) {
    if (type == TextInputType.emailAddress) return emailValidator(key, value);
    return notNullValidator(key, value);
  } else {
    return null;
  }
}
