import 'package:flutter/material.dart';

class CustomDateField extends StatelessWidget {
  final String label;
  final String hint;
  final bool readOnly;
  final DateTime? value;
  final ValueChanged<DateTime?>? onChanged;

  const CustomDateField({
    super.key,
    required this.label,
    required this.hint,
    this.readOnly = false,
    this.value,
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
      initialDate: value ?? DateTime.now(),
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
    final text = value != null ? _fmt(value!) : '';

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
          fillColor: const Color(0xFFFCFCFC),
          hintText: hint,
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
