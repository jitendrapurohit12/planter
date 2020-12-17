import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gmt_planter/constant/constant.dart';
import 'package:velocity_x/velocity_x.dart';

class AnimatedProgress extends StatelessWidget {
  final StreamController<double> controller;
  const AnimatedProgress({@required this.controller});

  @override
  Widget build(BuildContext context) {
    final width = context.screenWidth - 32;
    return ZStack([
      VxBox()
          .width(width)
          .height(16)
          .color(Colors.grey.withOpacity(0.3))
          .rounded
          .make(),
      StreamBuilder<double>(
        stream: controller.stream,
        initialData: 0,
        builder: (context, snapshot) {
          return VxAnimatedBox()
              .animDuration(1.seconds)
              .color(kColorPrimary)
              .width(snapshot.data * width)
              .height(16)
              .rounded
              .make();
        },
      ),
    ]).px16();
  }
}
