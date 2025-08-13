import 'package:expense_tracker/core/domain/entities/transaction_categories.dart';
import 'package:expense_tracker/features/transaction/providers/transaction_form_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/domain/models/transaction.dart' as model;

class TransactionNotifier extends Notifier<model.Transaction?> {
  @override
  model.Transaction build() {
    return model.Transaction(
      category: transactionCategories.first,
      amount: 0,
      date: DateTime.now(),
      details: '',
    );
  }

  Future<void> save() async {
    final amount = ref.read(amountProvider);
    final category = ref.read(categoryProvider);
    final date = ref.read(dateProvider);
    final description = ref.read(descriptionProvider);
    state = model.Transaction(
      category: category ?? transactionCategories.first,
      amount: amount,
      date: date ?? DateTime.now(),
      details: description ?? "",
    );
    debugPrint('kayıt başarılı: $state');
  }

  Future<void> delete() async {}

  Future<void> edit() async {}
}
