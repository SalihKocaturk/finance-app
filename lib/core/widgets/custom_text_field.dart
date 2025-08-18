import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.label,
    this.isPassword = false,
    required this.hintText,
    required this.onChanged,
    this.initialValue,
    this.maxLine = 1,
    this.isObscure = true,
    this.onVisibleIconPressed,
  });
  final String label;
  final bool isPassword;
  final String hintText;
  final Function(String) onChanged;
  final String? initialValue;
  final int maxLine; // controller eklenecek
  final bool isObscure;
  final Function()? onVisibleIconPressed;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      onChanged: onChanged,
      obscureText: isPassword ? isObscure : false,
      maxLines: maxLine,

      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        label: Text(label),
        filled: true,
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  isObscure ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: onVisibleIconPressed,
              )
            : null,
        fillColor: const Color(0xFFFCFCFC),
        hintText: hintText,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFDBDFE9)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFDBDFE9)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFDBDFE9)),
        ),
      ),
    );
  }
}
