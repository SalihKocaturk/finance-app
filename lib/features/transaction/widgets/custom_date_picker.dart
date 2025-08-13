import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF666666),
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _openPicker(context),
          behavior: HitTestBehavior.opaque,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(11),
              border: Border.all(color: Colors.grey.withAlpha(60)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: Row(
              children: [
                Icon(Icons.calendar_today, size: 18, color: Colors.grey.withAlpha(180)),
                const Gap(10),

                Expanded(
                  child: Text(
                    text.isEmpty ? hint : text,
                    style: TextStyle(
                      fontSize: 15,
                      color: text.isEmpty ? const Color(0xFF999999) : Colors.black,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
