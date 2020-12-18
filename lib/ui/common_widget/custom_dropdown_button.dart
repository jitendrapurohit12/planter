import 'package:flutter/material.dart';
import 'package:gmt_planter/constant/constant.dart';
import 'package:velocity_x/velocity_x.dart';

class CustomDropdownButton extends StatelessWidget {
  final List<String> options;
  final String value, hint;
  final bool isMandatory;
  final Function(String) onChanged;

  const CustomDropdownButton({
    @required this.options,
    this.value,
    @required this.hint,
    this.isMandatory = true,
    @required this.onChanged,
  });
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      isExpanded: true,
      hint: hint.text.make(),
      iconEnabledColor: kColorPrimaryDark,
      iconSize: 30,
      itemHeight: 66,
      value: value,
      items: options.map((value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
