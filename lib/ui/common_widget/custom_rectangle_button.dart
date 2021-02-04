import 'package:flutter/material.dart';
import 'package:gmt_planter/style/decorations.dart';
import 'package:velocity_x/velocity_x.dart';

class CustomRectangleButton extends StatelessWidget {
  final String title;
  final VoidCallback callback;
  final Color color;
  final double radius, padding, fontSize, letterSpacing;

  const CustomRectangleButton({
    this.title,
    this.callback,
    this.color = Colors.red,
    this.radius = 0,
    this.padding = 12,
    this.fontSize = 20,
    this.letterSpacing = 4,
  });
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: callback,
      color: color,
      shape: listTileShape(radius: radius),
      child: title.text
          .textStyle(
            Theme.of(context).textTheme.overline.copyWith(
                  color: Colors.white,
                  fontSize: fontSize,
                  letterSpacing: letterSpacing,
                ),
          )
          .make()
          .pOnly(top: padding, bottom: padding),
    );
  }
}
