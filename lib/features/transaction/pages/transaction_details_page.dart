import 'package:expense_tracker/features/transaction/providers/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/toast.dart';
import '../providers/transaction_form_providers.dart';
import '../widgets/category_dropdown_picker.dart';
import '../widgets/custom_date_picker.dart';
import '../widgets/custom_text_field.dart';

class TransactionDetailsPage extends ConsumerWidget {
  final int modeIndex;
  const TransactionDetailsPage({super.key, required this.modeIndex});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final category = ref.watch(categoryProvider);
    final date = ref.watch(dateProvider);
    final transactionNotifier = ref.read(transactionProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            CustomTextField(
              label: 'Tutar',
              hint: '₺0.00',
              leadingIcon: Icons.attach_money,
              onChanged: (value) {
                final parsedValue = double.tryParse(value);
                if (parsedValue != null) {
                  ref.read(amountProvider.notifier).state = parsedValue;
                } else {
                  showToast(message: 'Lütfen geçerli bir sayı giriniz');
                }
              },
            ),
            const SizedBox(height: 14),

            CategoryDropdownField(
              label: 'Kategori',
              hint: 'Kategori seç',
              modeIndex: modeIndex,
              leadingIcon: Icons.category,
              value: category,
              onChanged: (val) => ref.read(categoryProvider.notifier).state = val,
            ),
            const SizedBox(height: 14),

            CustomDateField(
              label: 'Tarih',
              hint: 'GG.AA.YYYY',
              value: date,
              onChanged: (val) => ref.read(dateProvider.notifier).state = val,
            ),
            const SizedBox(height: 14),

            CustomTextField(
              label: 'Açıklama',
              hint: 'İsteğe bağlı not...',
              leadingIcon: Icons.notes,
              maxLines: 3,
              onChanged: (val) => ref.read(descriptionProvider.notifier).state = val,
            ),

            const SizedBox(height: 24),
            SizedBox(
              height: 52,
              child: FilledButton.icon(
                onPressed: () {
                  transactionNotifier.save();
                },
                icon: const Icon(Icons.check),
                label: const Text('Kaydet'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
