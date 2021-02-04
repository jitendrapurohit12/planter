import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gmt_planter/constant/constant.dart';
import 'package:velocity_x/velocity_x.dart';

class CustomTextfield extends HookWidget {
  final BuildContext context;
  final String hint, prefilledText, initialValue;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final void Function(String) onChanged;
  final FocusNode myNode, nextNode;
  final TextAlign align;
  final bool isEnabled, isMandatory, hide;
  final int maxLength, maxLines, minLines;
  final Widget suffixIcon, leadingIcon;

  const CustomTextfield({
    @required this.context,
    @required this.hint,
    @required this.inputAction,
    @required this.myNode,
    this.inputType,
    this.onChanged,
    this.nextNode,
    this.maxLength,
    this.align = TextAlign.start,
    this.isEnabled = true,
    this.isMandatory = true,
    this.hide = false,
    this.maxLines = 1,
    this.minLines = 1,
    this.prefilledText,
    this.initialValue,
    this.suffixIcon,
    this.leadingIcon,
  }) : assert(context != null || hint != null || inputAction != null || myNode != null);

  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        TextField(
          focusNode: myNode,
          enabled: isEnabled,
          keyboardType: inputType,
          maxLength: maxLength,
          minLines: minLines,
          onChanged: onChanged,
          textInputAction: inputAction,
          obscureText: hide,
          textAlign: align,
          style: TextStyle(
            color: isEnabled ? Colors.black87 : Colors.black26,
          ),
          decoration: InputDecoration(
            hintText: hint,
            border: _borderDecoration(),
            enabledBorder: _borderDecoration(),
            errorBorder: _borderDecoration(),
            focusedBorder: _borderDecoration(),
            disabledBorder: _borderDecoration(),
            focusedErrorBorder: _borderDecoration(),
            contentPadding: const EdgeInsets.fromLTRB(24, 8, 8, 8),
            fillColor: kColorTextfieldBackground,
            filled: true,
            suffixIcon: suffixIcon,
            prefixIcon: leadingIcon,
            prefix: prefilledText != null ? Text(prefilledText) : null,
          ),
        )
      ],
    );
  }
}

OutlineInputBorder _borderDecoration() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
    borderSide: BorderSide.none,
  );
}
