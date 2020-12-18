import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final VoidCallback callback;

  const CustomButton({this.title, this.callback});
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: callback,
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.overline.copyWith(
              color: Colors.white,
              fontSize: 18,
              letterSpacing: 4,
            ),
      ),
    ).centered();
  }
}
