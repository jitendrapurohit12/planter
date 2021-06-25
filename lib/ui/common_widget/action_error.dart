import 'package:flutter/material.dart';
import 'package:gmt_planter/ui/common_widget/custom_button.dart';
import 'package:velocity_x/velocity_x.dart';

class ActionError extends StatelessWidget {
  final String error, actionTitle;
  final VoidCallback callback;

  const ActionError({
    @required this.error,
    @required this.actionTitle,
    @required this.callback,
  });
  @override
  Widget build(BuildContext context) {
    return VStack([
      error.text.red600.xl2.center.make().px32(),
      32.heightBox,
      CustomButton(title: actionTitle, callback: callback),
    ]);
  }
}
