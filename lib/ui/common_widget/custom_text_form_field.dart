import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gmt_planter/constant/constant.dart';
import 'package:gmt_planter/style/text_styles.dart';
import 'package:gmt_planter/validator/validator.dart';
import 'package:velocity_x/velocity_x.dart';

class CustomTextFormField extends HookWidget {
  final BuildContext context;
  final String hint, prefilledText, initialValue;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final String Function(String) onValidate;
  final void Function(String) onSave, onChanged;
  final FocusNode myNode, nextNode;
  final TextAlign align;
  final bool isEnabled, isMandatory, hide, showTitle, showHint;
  final int maxLength, maxLines, minLines;
  final Widget suffixIcon, leadingIcon;

  const CustomTextFormField({
    @required this.context,
    @required this.hint,
    @required this.inputAction,
    @required this.onSave,
    @required this.myNode,
    this.onValidate,
    this.inputType,
    this.onChanged,
    this.nextNode,
    this.maxLength,
    this.align = TextAlign.start,
    this.isEnabled = true,
    this.isMandatory = true,
    this.hide = false,
    this.showHint = false,
    this.maxLines = 1,
    this.minLines = 1,
    this.prefilledText,
    this.initialValue,
    this.suffixIcon,
    this.leadingIcon,
    this.showTitle = true,
  }) : assert(context != null ||
            hint != null ||
            inputAction != null ||
            onSave != null ||
            myNode != null);

  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        if (showTitle)
          Padding(
            padding: EdgeInsets.only(left: context.percentWidth * 4),
            child: Text(
              hint,
              style: hintStyle(context: context),
            ),
          ),
        if (showTitle) SizedBox(height: context.percentHeight),
        TextFormField(
          focusNode: myNode,
          enabled: isEnabled,
          keyboardType: inputType,
          maxLength: maxLength,
          minLines: minLines,
          onChanged: onChanged,
          onSaved: onSave,
          initialValue: initialValue,
          validator: (value) => onValidate != null
              ? onValidate(value)
              : getValidatorBasedOnInputType(
                  key: hint,
                  type: inputType,
                  value: value,
                  isMandatory: isMandatory,
                ),
          textInputAction: inputAction,
          obscureText: hide,
          textAlign: align,
          style: TextStyle(
            color: isEnabled ? Colors.black87 : Colors.black26,
          ),
          decoration: InputDecoration(
            hintText: showHint ? hint : null,
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
