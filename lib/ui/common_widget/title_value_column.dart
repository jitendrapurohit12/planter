import 'package:flutter/material.dart';
import 'package:gmt_planter/style/text_styles.dart';
import 'package:velocity_x/velocity_x.dart';

class TitleValueColumn extends StatelessWidget {
  final String title, value;
  const TitleValueColumn({this.title, this.value});

  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        title.text
            .textStyle(
              primaryTextStyle(context: context),
            )
            .make(),
        const HeightBox(16),
        VxBox(child: value.text.make().wFull(context).p(16))
            .roundedSM
            .color(Colors.blue.withOpacity(0.05))
            .make(),
      ],
    ).pLTRB(16, 24, 16, 0);
  }
}
