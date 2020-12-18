import 'package:flutter/material.dart';
import 'package:gmt_planter/ui/common_widget/custom_dropdown_button.dart';
import 'package:velocity_x/velocity_x.dart';

class PageStory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ph = context.percentHeight;
    return VStack([
      HeightBox(ph * 3),
      CustomDropdownButton(
        options: ['A', 'B', 'C', 'D'],
        onChanged: (s) => print(s),
      ),
    ]).scrollVertical();
  }
}
