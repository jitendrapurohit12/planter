import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gmt_planter/constant/constant.dart';

class ClikableText extends StatelessWidget {
  final List<String> texts;
  final Function(String, int) callback;

  const ClikableText({@required this.texts, @required this.callback});
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          for (int i = 0; i < texts.length; i++)
            TextSpan(
              text: texts[i],
              style: TextStyle(
                color: i % 2 == 0
                    ? Theme.of(context).textTheme.bodyText2.color
                    : kColorPrimary,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () => i % 2 == 0 ? null : callback(texts[i], i),
            )
        ],
      ),
    );
  }
}
