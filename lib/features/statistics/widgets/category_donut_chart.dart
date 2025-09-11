// features/statistics/widgets/category_donut_chart.dart
import 'dart:math';

import 'package:expense_tracker/core/extensions/transaction_extensions.dart';
import 'package:expense_tracker/core/widgets/sheets/no_data_widget.dart';
import 'package:expense_tracker/features/statistics/widgets/legend_row.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/domain/enums/transaction_currency.dart';
import '../../../core/domain/enums/transaction_type.dart';
import '../../../core/domain/models/transaction.dart';
import '../../../core/domain/models/transaction_category.dart';
import '../../../core/providers/currency_provider.dart';
import 'aggregate.dart';

class CategoryDonutChart extends StatelessWidget {
  final List<Transaction> transactions;
  final WidgetRef ref;

  const CategoryDonutChart({
    super.key,
    required this.transactions,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    final currencyType = ref.watch(currencyTypeProvider);
    final currencySymbol = currencyType == CurrencyType.tl
        ? '₺'
        : currencyType == CurrencyType.usd
        ? r'$'
        : '€';
    //kategorlere göre toplam değer ayrılır
    final Map<int, Aggregate> byCategory = {};
    for (final transaction in transactions) {
      final id = transaction.category.id;
      byCategory.putIfAbsent(id, () => Aggregate(0, transaction.category));
      final val = double.tryParse(transaction.uiPrice(ref)) ?? 0.0;
      byCategory[id] = byCategory[id]!.copyWith(sum: byCategory[id]!.sum + val);
    }

    final total = byCategory.values.fold<double>(0, (s, a) => s + a.sum);
    if (total <= 0) return const NoDataWidget();
    //gelir gider ayrımı
    final expenses = byCategory.values.where((a) => a.category.type == TransactionType.expense).toList()
      ..sort((a, b) => b.sum.compareTo(a.sum));
    final incomes = byCategory.values.where((a) => a.category.type == TransactionType.income).toList()
      ..sort((a, b) => b.sum.compareTo(a.sum));
    final ordered = [...expenses, ...incomes];
    //categoryyye göre renklendirme
    final sections = ordered.map((a) {
      final color = _categoryColor(a.category);
      final percentage = (a.sum / total * 100);
      return PieChartSectionData(
        value: a.sum,
        color: color,
        title: '${percentage.toStringAsFixed(0)}%',
        radius: 42,
        titleStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
        showTitle: percentage >= 5,
      );
    }).toList();

    final legend = ordered.map((a) {
      return LegendRow(
        color: _categoryColor(a.category),
        label: a.category.label,
        valueText: '${(a.sum)} $currencySymbol',
      );
    }).toList();

    return Card(
      elevation: 0,
      color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1C2741) : const Color(0xFFF4F6FB),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Kategoriler',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: AspectRatio(
                      aspectRatio: 1.05,
                      child: PieChart(
                        PieChartData(
                          sections: sections,
                          centerSpaceRadius: 40,
                          sectionsSpace: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                      child: Wrap(
                        runSpacing: 10,
                        children: legend,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Color _categoryColor(TransactionCategory c) {
    final rnd = Random(c.id);
    int chan() => 50 + rnd.nextInt(180);
    return Color.fromARGB(255, chan(), chan(), chan());
  }
}
