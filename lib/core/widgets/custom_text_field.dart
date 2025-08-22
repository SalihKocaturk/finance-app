import 'package:flutter/material.dart';

import 'visibility_button_builder.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.label,
    this.isPassword = false,
    this.inputType = TextInputType.text,
    required this.hintText,
    required this.onChanged,
    this.initialValue,
    this.maxLine = 1,
    this.initialObscure = true,
    this.onObscureChanged,
  });

  final String label;
  final bool isPassword;
  final TextInputType inputType;
  final String hintText;
  final ValueChanged<String> onChanged;
  final String? initialValue;
  final int maxLine;
  final bool initialObscure;
  final ValueChanged<bool>? onObscureChanged;

  @override
  Widget build(BuildContext context) {
    if (!isPassword) {
      return TextFormField(
        keyboardType: inputType,
        initialValue: initialValue,
        onChanged: onChanged,
        maxLines: maxLine,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
        ),
      );
    }

    return VisibilityButtonBuilder(
      initialObscure: initialObscure,
      onChanged: onObscureChanged,
      builder: (context, obscure, iconButton) {
        return TextFormField(
          keyboardType: inputType,
          initialValue: initialValue,
          onChanged: onChanged,
          obscureText: obscure,
          maxLines: 1,
          decoration: InputDecoration(
            labelText: label,
            hintText: hintText,
            suffixIcon: iconButton,
          ),
        );
      },
    );
  }
}
