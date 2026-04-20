import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:finance_tracker/app/extensions/currency.dart';
import 'package:finance_tracker/viewmodels/app_viewmodel.dart';
import 'package:finance_tracker/viewmodels/budget_viewmodel.dart';
import 'package:finance_tracker/l10n/generated/app_localizations.dart';
import 'package:finance_tracker/widgets/budget/budget_surface.dart';

class IncomeVsExpenseCard extends StatelessWidget {
  const IncomeVsExpenseCard({
    super.key,
    required this.appViewmodel,
    required this.viewmodel,
  });

  final AppViewmodel appViewmodel;
  final BudgetViewmodel viewmodel;

  @override
  Widget build(BuildContext context) {
    return BudgetSurface(
      title:
          "${AppLocalizations.of(context)!.incomes} V/s ${AppLocalizations.of(context)!.expenses}",
      subtitle:
          'Follow how money in and money out move across the budget period.',
      child: Container(
        height: 230,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF9FAFF), Color(0xFFF4F6FD)],
          ),
          border: Border.all(color: const Color(0xFFE6EAF2)),
        ),
        child: LineChart(
          LineChartData(
            titlesData: FlTitlesData(
              topTitles: const AxisTitles(),
              leftTitles: const AxisTitles(),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (double value, TitleMeta meta) {
                    final dateIndex = value.toInt();
                    if (dateIndex >= 0 &&
                        dateIndex < viewmodel.rangeDates.length) {
                      final date = viewmodel.rangeDates[dateIndex];
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          "${date.day}",
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ),
            gridData: FlGridData(
              drawVerticalLine: false,
              horizontalInterval: null,
              getDrawingHorizontalLine: (_) =>
                  const FlLine(color: Color(0xFFE5EAF3), strokeWidth: 1),
            ),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                curveSmoothness: 0.02,
                spots: [
                  ...viewmodel.dailyTotalTransactions.mapIndexed(
                    (i, t) => FlSpot(
                      i.toDouble(),
                      t.paymentsTotal.toCurrency().roundToDouble(),
                    ),
                  ),
                ],
                isCurved: true,
                color: appViewmodel.paymentColor,
                barWidth: 3,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  color: appViewmodel.paymentColor.withValues(alpha: 0.08),
                ),
              ),
              LineChartBarData(
                curveSmoothness: 0.02,
                spots: [
                  ...viewmodel.dailyTotalTransactions.mapIndexed(
                    (i, t) => FlSpot(
                      i.toDouble(),
                      t.receiptsTotal.toCurrency().roundToDouble(),
                    ),
                  ),
                ],
                isCurved: true,
                color: appViewmodel.receiptColor,
                barWidth: 3,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  color: appViewmodel.receiptColor.withValues(alpha: 0.08),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
