import 'package:flutter/material.dart';
import 'package:gmt_planter/constant/constant.dart';

TextStyle hintStyle({@required BuildContext context}) => Theme.of(context)
    .textTheme
    .subtitle2
    .copyWith(fontWeight: FontWeight.bold, color: Colors.black);

TextStyle buttonStyle({@required BuildContext context}) =>
    Theme.of(context).textTheme.headline6.copyWith(color: Colors.white);

TextStyle whiteTitleStyle({@required BuildContext context}) =>
    Theme.of(context).textTheme.overline.copyWith(
          color: Colors.white,
          fontSize: 19,
          fontWeight: FontWeight.w700,
        );
TextStyle receiptTitleStyle({@required BuildContext context}) =>
    Theme.of(context).textTheme.overline.copyWith(
          color: Colors.black54,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        );

TextStyle primaryHeadTextStyle({@required BuildContext context}) =>
    Theme.of(context).textTheme.headline6.copyWith(color: kColorPrimary);

TextStyle primaryTextStyle({@required BuildContext context}) =>
    Theme.of(context).textTheme.bodyText2.copyWith(color: kColorPrimary);

TextStyle tabStyle({@required BuildContext context}) =>
    Theme.of(context).textTheme.button.copyWith(
        fontWeight: FontWeight.bold, color: Colors.black.withOpacity(0.7));
