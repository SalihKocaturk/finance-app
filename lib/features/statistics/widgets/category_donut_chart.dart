// features/statistics/widgets/category_donut_chart.dart
import 'dart:math';

import 'package:expense_tracker/core/extensions/transaction_extensions.dart';
import 'package:expense_tracker/features/statistics/widgets/legend_row.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/domain/enums/transaction_currency.dart';
import '../../../core/domain/enums/transaction_type.dart';
import '../../../core/domain/models/transaction.dart';
import '../../../core/domain/models/transaction_category.dart';
import '../../../core/providers/currency_provider.dart';
import 'Aggregate.dart';

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
    final currencySymbol = _symbolFor(currencyType);

    final Map<int, Aggregate> byCat = {};
    for (final t in transactions) {
      final id = t.category.id;
      byCat.putIfAbsent(id, () => Aggregate(0, t.category));
      final val = double.tryParse(t.uiPrice(ref)) ?? 0.0;
      byCat[id] = byCat[id]!.copyWith(sum: byCat[id]!.sum + val);
    }

    final total = byCat.values.fold<double>(0, (s, a) => s + a.sum);
    if (total <= 0) return _emptyCard(context, 'No data');

    final expenses = byCat.values.where((a) => a.category.type == TransactionType.expense).toList()
      ..sort((a, b) => b.sum.compareTo(a.sum));
    final incomes = byCat.values.where((a) => a.category.type == TransactionType.income).toList()
      ..sort((a, b) => b.sum.compareTo(a.sum));
    final ordered = [...expenses, ...incomes];

    final sections = ordered.map((a) {
      final col = _categoryColor(a.category);
      final pct = (a.sum / total * 100);
      return PieChartSectionData(
        value: a.sum,
        color: col,
        title: '${pct.toStringAsFixed(0)}%',
        radius: 42,
        titleStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
        showTitle: pct >= 5,
      );
    }).toList();

    final legend = ordered.map((a) {
      return LegendRow(
        color: _categoryColor(a.category),
        label: a.category.label,
        valueText: '${_shortMoney(a.sum)} $currencySymbol',
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

  // Kategoriye göre stabil-rastgele renk
  static Color _categoryColor(TransactionCategory c) {
    final rnd = Random(c.id);
    int chan() => 50 + rnd.nextInt(180); // 50–230 arası kanal: orta-parlak renkler
    return Color.fromARGB(255, chan(), chan(), chan());
  }

  static String _symbolFor(CurrencyType t) {
    switch (t) {
      case CurrencyType.usd:
        return r'$';
      case CurrencyType.eur:
        return '€';
      case CurrencyType.tl:
      default:
        return '₺';
    }
  }

  static String _shortMoney(double v) {
    if (v >= 1e9) return '${(v / 1e9).toStringAsFixed(1)}B';
    if (v >= 1e6) return '${(v / 1e6).toStringAsFixed(1)}M';
    if (v >= 1e3) return '${(v / 1e3).toStringAsFixed(1)}K';
    return v.toStringAsFixed(0);
  }

  Widget _emptyCard(BuildContext context, String text) => Card(
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Center(child: Text(text, style: Theme.of(context).textTheme.bodyMedium)),
    ),
  );
}
