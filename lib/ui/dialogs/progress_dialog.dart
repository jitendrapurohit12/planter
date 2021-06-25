import 'package:flutter/material.dart';
import 'package:gmt_planter/helper/platform_widgets.dart';
import 'package:velocity_x/velocity_x.dart';

class ProgressDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(vertical: 48, horizontal: 16),
      child: SizedBox(
        width: double.maxFinite,
        height: 100,
        child: HStack(
          [
            getPlatformProgress(),
            48.widthBox,
            'Logging out...'.text.xl2.makeCentered(),
          ],
        ).centered(),
      ),
    );
  }
}
