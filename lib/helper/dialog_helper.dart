import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:meta/meta.dart';

Future<String> showActionDialog({
  @required BuildContext context,
  @required String title,
  @required String content,
  @required String button1,
  @required String button2,
  String button3,
  Color color1,
  Color color2,
  Color color3,
}) async {
  assert(title != null);
  assert(context != null);
  assert(button2 != null);
  assert(button1 != null);
  assert(content != null);

  final value = await showDialog(
    context: context,
    builder: (_) {
      final isAndroid = Platform.isAndroid;
      return PlatformAlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          PlatformDialogAction(
            onPressed: () => Navigator.pop(context, button1),
            child: Text(
              isAndroid ? button1.toUpperCase() : button1,
              style: TextStyle(color: color1),
            ),
          ),
          PlatformDialogAction(
            onPressed: () => Navigator.pop(context, button2),
            child: Text(
              isAndroid ? button2.toUpperCase() : button2,
              style: TextStyle(color: color2),
            ),
          ),
          if (button3 != null)
            PlatformDialogAction(
              onPressed: () => Navigator.pop(context, button3),
              child: Text(
                isAndroid ? button3.toUpperCase() : button3,
                style: TextStyle(color: color3),
              ),
            )
          else
            const SizedBox.shrink(),
        ],
      );
    },
  );

  return value as String;
}
