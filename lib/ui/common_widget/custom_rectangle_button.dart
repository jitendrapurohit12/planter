import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class CustomRectangleButton extends StatelessWidget {
  final String title;
  final VoidCallback callback;
  final Color color;
  final double radius;

  const CustomRectangleButton({
    this.title,
    this.callback,
    this.color,
    this.radius = 0,
  });
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: callback,
      color: Colors.red,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      child: title.text
          .textStyle(
            Theme.of(context).textTheme.overline.copyWith(
                  color: Colors.white,
                  fontSize: 20,
                  letterSpacing: 4,
                ),
          )
          .make()
          .py12(),
    );
  }
}
