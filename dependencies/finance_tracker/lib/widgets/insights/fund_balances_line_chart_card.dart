import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:finance_tracker/app/global/colors.dart';
import 'package:finance_tracker/app/global/dimensions.dart';
import 'package:finance_tracker/l10n/generated/app_localizations.dart';
import 'package:finance_tracker/viewmodels/insights_viewmodel.dart';

class FundBalancesLineChartCard extends StatelessWidget {
  const FundBalancesLineChartCard({
    super.key,
    required this.viewmodel,
  });

  final InsightsViewmodel viewmodel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.fundsBalance,
                          style:
                              theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Review how each fund balance moved during the selected date range.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: const Color(0xFF6B6B80),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton.icon(
                    onPressed: () => _openFundSelector(context),
                    icon: const Icon(Icons.tune_rounded, size: 18),
                    label: const Text('Funds'),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: viewmodel.fundBalances.keys.mapIndexed((index, fund) {
                  final color = materialColors.reversed.toList()[
                      index % materialColors.length];
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F8FC),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: const Color(0xFFE7E7EC)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          fund.name,
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
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
                child: LineChart(
                  LineChartData(
                    lineTouchData: const LineTouchData(enabled: false),
                    gridData: FlGridData(
                      drawVerticalLine: false,
                      horizontalInterval: 1,
                      getDrawingHorizontalLine: (_) => const FlLine(
                        color: Color(0xFFE7E7EC),
                        strokeWidth: 1,
                      ),
                    ),
                    titlesData: FlTitlesData(
                      topTitles: const AxisTitles(),
                      rightTitles: const AxisTitles(),
                      leftTitles: const AxisTitles(),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 28,
                          getTitlesWidget: (value, meta) {
                            final dateIndex = value.toInt();
                            if (dateIndex >= 0 &&
                                dateIndex < viewmodel.rangeDates.length) {
                              final date = viewmodel.rangeDates[dateIndex];
                              return Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  '${date.day}',
                                  style: theme.textTheme.labelSmall,
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    lineBarsData: viewmodel.fundBalances.entries.mapIndexed((
                      index,
                      entry,
                    ) {
                      final color = materialColors.reversed.toList()[
                          index % materialColors.length];
                      return LineChartBarData(
                        curveSmoothness: 0.18,
                        isCurved: true,
                        barWidth: 3,
                        spots: entry.value.mapIndexed((spotIndex, balance) {
                          return FlSpot(
                            spotIndex.toDouble(),
                            balance.toDouble(),
                          );
                        }).toList(),
                        color: color,
                        gradient: LinearGradient(
                          colors: [color.withAlpha(150), color],
                        ),
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              color.withAlpha(40),
                              color.withAlpha(0),
                            ],
                          ),
                        ),
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
        .animate(delay: 100.ms)
        .scale(begin: const Offset(1.02, 1.02), duration: 120.ms)
        .fade(curve: Curves.easeInOut, duration: 120.ms);
  }

  void _openFundSelector(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.funds,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Hide or show funds in the balance trend chart.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF6B6B80),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...viewmodel.funds.mapIndexed((index, fund) {
                      final color = materialColors.reversed.toList()[
                          index % materialColors.length];
                      return CheckboxListTile(
                        value: !viewmodel.selectedFundsForBalanceChart
                            .contains(fund.dbID),
                        contentPadding: EdgeInsets.zero,
                        title: Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: color,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(child: Text(fund.name)),
                          ],
                        ),
                        onChanged: (_) {
                          viewmodel.addToFilter(a: fund.dbID);
                          setState(() {});
                        },
                      );
                    }),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
