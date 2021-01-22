import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gmt_planter/ui/common_widget/custom_rectangle_button.dart';
import 'package:velocity_x/velocity_x.dart';

class UnconfirmedSheet extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final ph = context.percentHeight;
    final pw = context.percentWidth;
    return VStack([
      Expanded(
        child: PageView.builder(
          itemBuilder: (_, index) {
            return VxCard(VxBox(child: 'This is Page No. $index'.text.xl4.green700.makeCentered())
                    .width(pw * 80)
                    .height(ph * 50)
                    .make())
                .roundedSM
                .makeCentered();
          },
          itemCount: 20,
        ),
      ),
      Container(
        width: double.maxFinite,
        color: Colors.red,
        child: CustomRectangleButton(
          callback: () {},
          color: Colors.red,
          title: 'CANCEL',
        ),
      ),
    ]);
  }
}
