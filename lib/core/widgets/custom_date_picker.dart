import 'package:flutter/material.dart';

class CustomDateField extends StatelessWidget {
  final String label;
  final String hintText;
  final bool readOnly;
  final DateTime? initialValue;
  final ValueChanged<DateTime?>? onChanged;

  const CustomDateField({
    super.key,
    required this.label,
    required this.hintText,
    this.readOnly = false,
    this.initialValue,
    this.onChanged,
  });

  String _fmt(DateTime d) {
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    final yy = d.year.toString();
    return '$dd.$mm.$yy';
  }

  Future<void> _openPicker(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: initialValue ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.black,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) onChanged?.call(picked);
  }

  @override
  Widget build(BuildContext context) {
    final text = initialValue != null ? _fmt(initialValue!) : '';

    return GestureDetector(
      onTap: () => _openPicker(context),
      behavior: HitTestBehavior.opaque,
      child: InputDecorator(
        isFocused: false,
        isEmpty: text.isEmpty,
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          label: Text(label),
          filled: true,
          hintText: hintText,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
        child: Text(
          text.isEmpty ? '' : text,
          style: TextStyle(
            fontSize: 15,
            color: text.isEmpty ? const Color(0xFF999999) : Colors.black,
          ),
        ),
      ),
    );
  }
}
