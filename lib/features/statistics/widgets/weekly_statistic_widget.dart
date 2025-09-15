import 'package:expense_tracker/core/domain/enums/transaction_type.dart';
import 'package:expense_tracker/core/domain/models/transaction.dart';
import 'package:expense_tracker/core/extensions/transaction_extensions.dart';
import 'package:expense_tracker/features/statistics/widgets/legend_dot.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WeeklyTransactionsChart extends StatelessWidget {
  final List<Transaction> transactions;
  final WidgetRef ref;
  const WeeklyTransactionsChart({
    super.key,
    required this.transactions,
    required this.ref,
  });

  static const incomeColor = Colors.green;
  static const expenseColor = Color(0xFFE74C3C);
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final start = today.subtract(const Duration(days: 6));
    final daysList = List.generate(7, (i) => start.add(Duration(days: i)));

    final indexOfDay = {for (int i = 0; i < daysList.length; i++) daysList[i]: i};

    final income = List<double>.filled(7, 0.0);
    final expense = List<double>.filled(7, 0.0);
    if (transactions.isEmpty) return const SizedBox();
    for (final transaction in transactions) {
      final d = DateTime(transaction.date.year, transaction.date.month, transaction.date.day);
      final idx = indexOfDay[d];
      if (idx == null) continue;
      if (transaction.category.type == TransactionType.income) {
        income[idx] += num.parse(transaction.uiPrice(ref));
      } else if (transaction.category.type == TransactionType.expense) {
        expense[idx] += num.parse(transaction.uiPrice(ref));
      }
    }

    const labels = ['Mn', 'Tu', 'Wd', 'Th', 'Fr', 'St', 'Sn'];
    final dayLabels = daysList.map((days) => labels[(days.weekday - 1).clamp(0, 6)]).toList(growable: false);

    final all = <double>[...income, ...expense];
    final maxVal = all.isEmpty ? 0.0 : all.reduce((a, b) => a > b ? a : b);
    final maxY = (maxVal * 1.15).clamp(1000, double.infinity).toDouble();

    final groups = List.generate(7, (i) {
      return BarChartGroupData(
        x: i,
        barsSpace: 6,
        barRods: [
          BarChartRodData(
            toY: expense[i],
            width: 10,
            color: expenseColor,
            borderRadius: BorderRadius.circular(4),
          ),
          BarChartRodData(
            toY: income[i],
            width: 10,
            color: incomeColor,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    });

    return Card(
      elevation: 0,
      color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1C2741) : const Color(0xFFF4F6FB),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Transactions',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                const LegendDot(color: incomeColor, label: 'Income'),
                const SizedBox(width: 12),
                const LegendDot(color: expenseColor, label: 'Expense'),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 260,
              child: BarChart(
                BarChartData(
                  maxY: maxY,
                  minY: 0,
                  groupsSpace: 14,
                  barGroups: groups,
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: _chooseInterval(maxY),
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: Colors.white.withAlpha(8),
                      strokeWidth: 1,
                    ),
                  ),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        getTitlesWidget: (value, meta) {
                          final i = value.toInt();
                          return Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              i >= 0 && i < dayLabels.length ? dayLabels[i] : '',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        interval: _chooseInterval(maxY),
                        getTitlesWidget: (value, meta) {
                          if (value == 0) return const SizedBox.shrink();
                          final label = value >= 1000 ? '${(value ~/ 1000)}K' : value.toStringAsFixed(0);
                          return Text(
                            label,
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Theme.of(context).textTheme.labelSmall?.color?.withAlpha(70),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static double _chooseInterval(double maxY) {
    if (maxY <= 2_000) return 500;
    if (maxY <= 5_000) return 1_000;
    if (maxY <= 10_000) return 2_000;
    if (maxY <= 20_000) return 4_000;

    if (maxY <= 100_000) return 10_000;
    if (maxY <= 500_000) return 25_000;

    if (maxY <= 5_000_000) return 50_000;
    if (maxY <= 10_000_000) return 250_000;

    return 500_000;
  }
}
