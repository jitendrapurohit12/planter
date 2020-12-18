import 'package:flutter/material.dart';

class CustomDropdownButton extends StatelessWidget {
  final List<String> options;
  final String value;
  final bool isMandatory;
  final Function(String) onChanged;

  const CustomDropdownButton({
    @required this.options,
    this.value,
    this.isMandatory = true,
    @required this.onChanged,
  });
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: value ?? options[0],
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
