import 'package:flutter/material.dart';

import '../../../core/domain/enums/transaction_type.dart';

class CategoryDialog extends StatelessWidget {
  final String title;
  final String name;
  final TransactionType type;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<TransactionType> onTypeChanged;
  final VoidCallback onCancel;
  final VoidCallback onSave;

  const CategoryDialog({
    super.key,
    required this.title,
    required this.name,
    required this.type,
    required this.onNameChanged,
    required this.onTypeChanged,
    required this.onCancel,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 16),

              const Text('Kategori adı', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Örn: Market',
                  border: OutlineInputBorder(),
                ),
                onChanged: onNameChanged,
              ),

              const SizedBox(height: 12),

              InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Tür',
                  border: OutlineInputBorder(),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<TransactionType>(
                    value: type,
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(value: TransactionType.income, child: Text('Gelir')),
                      DropdownMenuItem(value: TransactionType.expense, child: Text('Gider')),
                    ],
                    onChanged: (v) {
                      if (v != null) onTypeChanged(v);
                    },
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(onPressed: onCancel, child: const Text('İptal')),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: onSave,
                      icon: const Icon(Icons.check),
                      label: const Text('Ekle'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
