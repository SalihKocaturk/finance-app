import 'dart:math';

import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';

import '../../../core/domain/enums/transaction_type.dart';
import '../../../core/domain/models/transaction_category.dart';

final transactionCategoriesProvider = NotifierProvider<TransactionCategoriesNotifier, List<TransactionCategory>>(
  TransactionCategoriesNotifier.new,
);

class TransactionCategoriesNotifier extends Notifier<List<TransactionCategory>> {
  @override
  List<TransactionCategory> build() => [];

  TransactionCategory add({
    required String name,
    required TransactionType type,
  }) {
    const IconData fixedIcon = Icons.category;
    final Color randomColor = Colors.primaries[Random().nextInt(Colors.primaries.length)];

    final newCat = TransactionCategory.fromIcon(
      id: DateTime.now().millisecondsSinceEpoch,
      label: name,
      icon: fixedIcon,
      color: randomColor,
      type: type,
    );

    state = [...state, newCat];
    return newCat;
  }
}
