import 'package:flutter/material.dart';
import 'package:gmt_planter/constant/constant.dart';
import 'package:velocity_x/velocity_x.dart';

class BulletRow extends StatelessWidget {
  final String title, value;

  const BulletRow(this.title, this.value);

  @override
  Widget build(BuildContext context) {
    final titleUI = title.text.make().expand(flex: 3);
    final bulletUI = VxBox().color(kColorPrimary).rounded.make().w(10).h(6);
    final valueUI = value.text.bold.color(kColorPrimaryDark).make().objectTopLeft().expand(flex: 2);
    return HStack([24.widthBox, bulletUI, 16.widthBox, titleUI, valueUI, 24.widthBox]).py(8);
  }
}
