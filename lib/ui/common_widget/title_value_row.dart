import 'package:flutter/material.dart';
import 'package:gmt_planter/style/text_styles.dart';
import 'package:velocity_x/velocity_x.dart';

class TitleValueRow extends StatelessWidget {
  final String title, value;
  const TitleValueRow({this.title, this.value});

  @override
  Widget build(BuildContext context) {
    return HStack(
      [
        title.text
            .textStyle(
              primaryTextStyle(context: context),
            )
            .make(),
        const HeightBox(16),
        value.text.make(),
      ],
      alignment: MainAxisAlignment.spaceBetween,
      axisSize: MainAxisSize.max,
    ).pLTRB(16, 24, 16, 16);
  }
}
