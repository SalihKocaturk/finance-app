import 'package:flutter/material.dart';

import '../enums/transaction_category.dart';
import '../enums/transaction_type.dart';

const List<TransactionCategory> transactionCategories = [
  // GELİR TİPLERİ
  TransactionCategory(
    id: 1,
    label: 'Maaş',
    icon: Icons.payments,
    color: Colors.green,
    type: TransactionType.income,
  ),
  TransactionCategory(
    id: 2,
    label: 'Hediye (Gelir)',
    icon: Icons.card_giftcard,
    color: Colors.green,
    type: TransactionType.income,
  ),
  TransactionCategory(
    id: 3,
    label: 'Diğer (Gelir)',
    icon: Icons.more_horiz,
    color: Colors.grey,
    type: TransactionType.income,
  ),

  // GİDER TİPLERİ
  TransactionCategory(
    id: 10,
    label: 'Yemek',
    icon: Icons.restaurant,
    color: Colors.orange,
    type: TransactionType.expense,
  ),
  TransactionCategory(
    id: 13,
    label: 'Alışveriş',
    icon: Icons.shopping_bag,
    color: Colors.purple,
    type: TransactionType.expense,
  ),
  TransactionCategory(
    id: 14,
    label: 'Ulaşım',
    icon: Icons.directions_bus,
    color: Colors.indigo,
    type: TransactionType.expense,
  ),
  TransactionCategory(
    id: 17,
    label: 'Sağlık',
    icon: Icons.health_and_safety,
    color: Colors.red,
    type: TransactionType.expense,
  ),
  TransactionCategory(
    id: 18,
    label: 'Eğitim',
    icon: Icons.school,
    color: Colors.blue,
    type: TransactionType.expense,
  ),
  TransactionCategory(
    id: 19,
    label: 'Vergi',
    icon: Icons.request_page,
    color: Colors.deepOrange,
    type: TransactionType.expense,
  ),
  TransactionCategory(
    id: 22,
    label: 'Diğer (Gider)',
    icon: Icons.more_horiz,
    color: Colors.grey,
    type: TransactionType.expense,
  ),
];
