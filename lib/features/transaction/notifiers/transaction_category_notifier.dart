import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';

import '../../../core/domain/enums/transaction_type.dart';
import '../../../core/domain/models/transaction_category.dart';

class TransactionCategoriesNotifier extends Notifier<List<TransactionCategory>> {
  @override
  List<TransactionCategory> build() => [
    TransactionCategory.rename(
      id: 1,
      label: 'Maaş',
      icon: Icons.payments,
      color: Colors.green,
      type: TransactionType.income,
    ),
    TransactionCategory.rename(
      id: 2,
      label: 'Hediye (Gelir)',
      icon: Icons.card_giftcard,
      color: Colors.green,
      type: TransactionType.income,
    ),
    TransactionCategory.rename(
      id: 3,
      label: 'Diğer (Gelir)',
      icon: Icons.more_horiz,
      color: Colors.green,
      type: TransactionType.income,
    ),

    TransactionCategory.rename(
      id: 10,
      label: 'Yemek',
      icon: Icons.restaurant,
      color: Colors.red,
      type: TransactionType.expense,
    ),
    TransactionCategory.rename(
      id: 13,
      label: 'Alışveriş',
      icon: Icons.shopping_bag,
      color: Colors.red,
      type: TransactionType.expense,
    ),
    TransactionCategory.rename(
      id: 14,
      label: 'Ulaşım',
      icon: Icons.directions_bus,
      color: Colors.red,
      type: TransactionType.expense,
    ),
    TransactionCategory.rename(
      id: 17,
      label: 'Sağlık',
      icon: Icons.health_and_safety,
      color: Colors.red,
      type: TransactionType.expense,
    ),
    TransactionCategory.rename(
      id: 18,
      label: 'Eğitim',
      icon: Icons.school,
      color: Colors.red,
      type: TransactionType.expense,
    ),
    TransactionCategory.rename(
      id: 19,
      label: 'Vergi',
      icon: Icons.request_page,
      color: Colors.red,
      type: TransactionType.expense,
    ),
    TransactionCategory.rename(
      id: 22,
      label: 'Diğer (Gider)',
      icon: Icons.more_horiz,
      color: Colors.red,
      type: TransactionType.expense,
    ),
  ];

  TransactionCategory add({
    required String name,
    required TransactionType type,
  }) {
    const IconData fixedIcon = Icons.category;
    // final Color randomColor = Colors.primaries[Random().nextInt(Colors.primaries.length)];

    final newCat = TransactionCategory.rename(
      id: state.length + 1,
      label: name,
      icon: fixedIcon,
      color: type == TransactionType.expense ? Colors.red : Colors.green,
      type: type,
    );

    state = [...state, newCat];
    return newCat;
  }
}
