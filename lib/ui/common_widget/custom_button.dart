import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gmt_planter/constant/constant.dart';
import 'package:velocity_x/velocity_x.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final VoidCallback callback;

  const CustomButton({this.title, this.callback});
  @override
  Widget build(BuildContext context) {
    final child = Text(
      title.toUpperCase(),
      style: Theme.of(context).textTheme.overline.copyWith(
            color: Colors.white,
            fontSize: 18,
            letterSpacing: 4,
          ),
    );
    return Platform.isAndroid
        ? ElevatedButton(
            onPressed: callback,
            child: child,
          ).centered()
        : CupertinoButton(
            color: kColorPrimary,
            onPressed: callback,
            borderRadius: BorderRadius.circular(36),
            child: child,
          ).centered();
  }
}
