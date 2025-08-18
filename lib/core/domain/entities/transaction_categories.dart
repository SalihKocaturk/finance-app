// lib/core/domain/data/transaction_categories.dart
import 'package:flutter/material.dart';

import '../enums/transaction_type.dart';
import '../models/transaction_category.dart';

List<TransactionCategory> transactionCategories = [
  TransactionCategory.fromIcon(
    id: 1,
    label: 'Maaş',
    icon: Icons.payments,
    color: Colors.green,
    type: TransactionType.income,
  ),
  TransactionCategory.fromIcon(
    id: 2,
    label: 'Hediye (Gelir)',
    icon: Icons.card_giftcard,
    color: Colors.green,
    type: TransactionType.income,
  ),
  TransactionCategory.fromIcon(
    id: 3,
    label: 'Diğer (Gelir)',
    icon: Icons.more_horiz,
    color: Colors.grey,
    type: TransactionType.income,
  ),

  TransactionCategory.fromIcon(
    id: 10,
    label: 'Yemek',
    icon: Icons.restaurant,
    color: Colors.orange,
    type: TransactionType.expense,
  ),
  TransactionCategory.fromIcon(
    id: 13,
    label: 'Alışveriş',
    icon: Icons.shopping_bag,
    color: Colors.purple,
    type: TransactionType.expense,
  ),
  TransactionCategory.fromIcon(
    id: 14,
    label: 'Ulaşım',
    icon: Icons.directions_bus,
    color: Colors.indigo,
    type: TransactionType.expense,
  ),
  TransactionCategory.fromIcon(
    id: 17,
    label: 'Sağlık',
    icon: Icons.health_and_safety,
    color: Colors.red,
    type: TransactionType.expense,
  ),
  TransactionCategory.fromIcon(
    id: 18,
    label: 'Eğitim',
    icon: Icons.school,
    color: Colors.blue,
    type: TransactionType.expense,
  ),
  TransactionCategory.fromIcon(
    id: 19,
    label: 'Vergi',
    icon: Icons.request_page,
    color: Colors.deepOrange,
    type: TransactionType.expense,
  ),
  TransactionCategory.fromIcon(
    id: 22,
    label: 'Diğer (Gider)',
    icon: Icons.more_horiz,
    color: Colors.grey,
    type: TransactionType.expense,
  ),
];
