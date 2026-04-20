import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:finance_tracker/app/global/dimensions.dart';
import 'package:finance_tracker/core/enums/week_days.dart';
import 'package:finance_tracker/l10n/generated/app_localizations.dart';
import 'package:finance_tracker/viewmodels/insights_viewmodel.dart';

class AverageTransactionsBarChartCard extends StatelessWidget {
  const AverageTransactionsBarChartCard({
    super.key,
    required this.viewmodel,
  });

  final InsightsViewmodel viewmodel;

  @override
  Widget build(BuildContext context) {
    final highestAverage = viewmodel.weeklyAvgExpenses.values
        .expand((values) => values)
        .fold<int>(0, (highest, value) => value > highest ? value : highest);

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: cardWidth),
      child: Card(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(26),
          side: const BorderSide(color: Color(0xFFE7E7EC)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.averageExpenses,
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w800,
                                  ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Spot the weekdays where spending tends to peak.',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: const Color(0xFF6B6B80),
                                  ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF6F6FB),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE7E7EC)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Peak average',
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(color: const Color(0xFF747488)),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$highestAverage',
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Container(
                height: 260,
                padding: const EdgeInsets.fromLTRB(12, 18, 12, 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F8FC),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: const Color(0xFFE7E7EC)),
                ),
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    borderData: FlBorderData(show: false),
                    barTouchData: BarTouchData(enabled: false),
                    gridData: FlGridData(
                      drawVerticalLine: false,
                      getDrawingHorizontalLine: (_) => const FlLine(
                        color: Color(0xFFE7E7EC),
                        strokeWidth: 1,
                      ),
                    ),
                    titlesData: FlTitlesData(
                      leftTitles: const AxisTitles(),
                      topTitles: const AxisTitles(),
                      rightTitles: const AxisTitles(),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          reservedSize: 30,
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                WeekDays.values[value.toInt() - 1].short,
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    barGroups: viewmodel.weeklyAvgExpenses.entries.mapIndexed((
                      _,
                      entry,
                    ) {
                      final average = entry.value.average.roundToDouble();
                      return BarChartGroupData(
                        x: entry.key,
                        barRods: [
                          BarChartRodData(
                            width: 22,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8),
                              bottomLeft: Radius.circular(3),
                              bottomRight: Radius.circular(3),
                            ),
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF9CB6FF),
                                Color(0xFF5164D8),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            toY: average,
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    )
        .animate(delay: 150.ms)
        .scale(begin: const Offset(1.02, 1.02), duration: 120.ms)
        .fade(curve: Curves.easeInOut, duration: 120.ms);
  }
}
