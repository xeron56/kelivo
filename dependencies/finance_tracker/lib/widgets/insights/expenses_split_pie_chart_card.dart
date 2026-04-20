import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:finance_tracker/app/extensions/currency.dart';
import 'package:finance_tracker/app/global/colors.dart';
import 'package:finance_tracker/app/global/dimensions.dart';
import 'package:finance_tracker/l10n/generated/app_localizations.dart';
import 'package:finance_tracker/viewmodels/insights_viewmodel.dart';
import 'package:finance_tracker/widgets/shared/dot_indicator.dart';

class ExpensesSplitPieChartCard extends StatelessWidget {
  const ExpensesSplitPieChartCard({
    super.key,
    required this.viewmodel,
  });

  final InsightsViewmodel viewmodel;

  @override
  Widget build(BuildContext context) {
    final expenseTotal = viewmodel.expenseTotals.values.fold<int>(0, (sum, value) {
      return sum + value.abs();
    });

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: cardWidth),
      child: _InsightsChartCard(
        title: AppLocalizations.of(context)!.expensesSplit,
        subtitle: 'See which categories are driving the largest share of spending.',
        trailing: _TopStatPill(
          label: 'Categories',
          value: '${viewmodel.expenseTotals.length}',
        ),
        child: Column(
          children: [
            _ChartPanel(
              height: 280,
              child: PageView(
                controller: viewmodel.expCardpageController,
                onPageChanged: viewmodel.setExpCardPage,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: PieChart(
                          duration: const Duration(milliseconds: 300),
                          PieChartData(
                            pieTouchData: PieTouchData(enabled: false),
                            centerSpaceRadius: 42,
                            sectionsSpace: 3,
                            sections: viewmodel.expenseTotals.entries
                                .mapIndexed((index, entry) {
                              final color =
                                  materialColors[index % materialColors.length];
                              return PieChartSectionData(
                                title: viewmodel.getExpensePercentage(entry.value),
                                titleStyle: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                                titlePositionPercentageOffset: 1.18,
                                color: color,
                                radius: 74,
                                value: entry.value.abs().toCurrency(),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 148,
                          child: ListView.builder(
                          primary: false,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: viewmodel.expenseTotals.length,
                          itemBuilder: (context, index) {
                            final account =
                                viewmodel.expenseTotals.keys.elementAt(index);
                            final amount =
                                viewmodel.expenseTotals.values.elementAt(index);
                            final color =
                                materialColors[index % materialColors.length];

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(top: 4),
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      color: color,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          account.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelLarge
                                              ?.copyWith(
                                                fontWeight: FontWeight.w700,
                                              ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          viewmodel.getExpensePercentage(amount),
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelMedium
                                              ?.copyWith(
                                                color: const Color(0xFF6B6B80),
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  ListView.builder(
                    padding: EdgeInsets.zero,
                    primary: false,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: viewmodel.expenseTotals.length,
                    itemBuilder: (context, index) {
                      final account =
                          viewmodel.expenseTotals.keys.elementAt(index);
                      final amount =
                          viewmodel.expenseTotals.values.elementAt(index);
                      final color =
                          materialColors[index % materialColors.length];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE7E7EC)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    account.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    viewmodel.getExpensePercentage(amount),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: const Color(0xFF6B6B80),
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              (amount * -1).toCurrencyStringWSymbol(
                                viewmodel.selectedProfile.currency,
                              ),
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _InlineMetric(
                    label: 'Total spent',
                    value: expenseTotal.toCurrencyStringWSymbol(
                      viewmodel.selectedProfile.currency,
                    ),
                  ),
                ),
                SizedBox(
                  height: 12,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        DotsIndicator(
                          isActive: viewmodel.expCardPage == 0,
                          onTap: () async {
                            await viewmodel.animateToExpCardPage(0);
                          },
                        ),
                        DotsIndicator(
                          isActive: viewmodel.expCardPage == 1,
                          onTap: () async {
                            await viewmodel.animateToExpCardPage(1);
                          },
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    )
        .animate(delay: 0.ms)
        .scale(begin: const Offset(1.02, 1.02), duration: 120.ms)
        .fade(curve: Curves.easeInOut, duration: 120.ms);
  }
}

class _InsightsChartCard extends StatelessWidget {
  const _InsightsChartCard({
    required this.title,
    required this.subtitle,
    required this.child,
    this.trailing,
  });

  final String title;
  final String subtitle;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Card(
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
                        title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF6B6B80),
                        ),
                      ),
                    ],
                  ),
                ),
                if (trailing != null) ...[
                  const SizedBox(width: 12),
                  trailing!,
                ],
              ],
            ),
            const SizedBox(height: 18),
            child,
          ],
        ),
      ),
    );
  }
}

class _ChartPanel extends StatelessWidget {
  const _ChartPanel({required this.child, required this.height});

  final Widget child;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8FC),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE7E7EC)),
      ),
      child: child,
    );
  }
}

class _TopStatPill extends StatelessWidget {
  const _TopStatPill({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F6FB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE7E7EC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: const Color(0xFF747488),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _InlineMetric extends StatelessWidget {
  const _InlineMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: const Color(0xFF747488),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
