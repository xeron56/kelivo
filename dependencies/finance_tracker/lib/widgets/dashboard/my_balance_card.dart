import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:finance_tracker/app/extensions/currency.dart';
import 'package:finance_tracker/app/global/dimensions.dart';
import 'package:finance_tracker/core/models/domain/profile.dart';
import 'package:finance_tracker/l10n/generated/app_localizations.dart';
import 'package:finance_tracker/viewmodels/app_viewmodel.dart';
import 'package:finance_tracker/viewmodels/dashboard_viewmodel.dart';
import 'package:finance_tracker/viewmodels/main_viewmodel.dart';
import 'package:finance_tracker/widgets/dashboard/add_transaction_button_group.dart';

class MyBalanceCard extends StatelessWidget {
  const MyBalanceCard({
    super.key,
    required this.profile,
    required this.viewmodel,
    required this.isWide,
  });

  final Profile profile;
  final DashboardViewmodel viewmodel;
  final bool isWide;

  @override
  Widget build(BuildContext context) {
    final appViewmodel = Provider.of<AppViewmodel>(context);
    final balances = viewmodel.balances;
    final latestBalance = viewmodel.closingBalance;
    final previousBalance = balances.length > 1
        ? balances[balances.length - 2]
        : latestBalance;
    final balanceDelta = latestBalance - previousBalance;
    final hasBalanceGain = balanceDelta >= 0;
    final sparklineData = _buildSparklineData(balances);

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: isWide ? cardWidth * 2 + 32 : cardWidth + 40,
        minWidth: 300,
      ),
      child:
          Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: const Color(0xFFE7E7EC)),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0A000000),
                      blurRadius: 28,
                      offset: Offset(0, 12),
                    ),
                  ],
                ),
                child: isWide
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 7,
                            child: _BalanceSummary(
                              profile: profile,
                              latestBalance: latestBalance,
                              balanceDelta: balanceDelta,
                              hasBalanceGain: hasBalanceGain,
                              sparklineData: sparklineData,
                            ),
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            flex: 4,
                            child: _BalanceSidebar(
                              profile: profile,
                              viewmodel: viewmodel,
                              appViewmodel: appViewmodel,
                              delta: balanceDelta,
                            ),
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _BalanceSummary(
                            profile: profile,
                            latestBalance: latestBalance,
                            balanceDelta: balanceDelta,
                            hasBalanceGain: hasBalanceGain,
                            sparklineData: sparklineData,
                          ),
                          if (viewmodel.canAddTransaction) ...[
                            const SizedBox(height: 20),
                            AddTransactionButtonGroup(
                              appViewmodel: appViewmodel,
                              profile: profile,
                              viewmodel: viewmodel,
                              isWide: false,
                            ),
                          ],
                        ],
                      ),
              )
              .animate()
              .scale(begin: const Offset(1.01, 1.01), duration: 140.ms)
              .fade(curve: Curves.easeOut, duration: 180.ms),
    );
  }

  List<FlSpot> _buildSparklineData(List<int> balances) {
    if (balances.isEmpty) {
      return const [FlSpot(0, 0), FlSpot(1, 0)];
    }

    final startIndex = math.max(0, balances.length - 10);
    final sample = balances.sublist(startIndex);

    return List.generate(
      sample.length,
      (index) => FlSpot(index.toDouble(), sample[index].toDouble()),
    );
  }
}

class _BalanceSummary extends StatelessWidget {
  const _BalanceSummary({
    required this.profile,
    required this.latestBalance,
    required this.balanceDelta,
    required this.hasBalanceGain,
    required this.sparklineData,
  });

  final Profile profile;
  final int latestBalance;
  final int balanceDelta;
  final bool hasBalanceGain;
  final List<FlSpot> sparklineData;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final changeColor = hasBalanceGain
        ? const Color(0xFF268B5E)
        : const Color(0xFFC45B5B);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F5FB),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                AppLocalizations.of(context)!.myBalance,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: () {
                Provider.of<MainViewmodel>(context, listen: false).setIndex(1);
              },
              icon: const Icon(Icons.arrow_outward_rounded, size: 18),
              label: Text(AppLocalizations.of(context)!.details),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Text(
          latestBalance.toCurrencyStringWSymbol(profile.currency),
          style: theme.textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.w700,
            height: 1.05,
          ),
          textScaler: const TextScaler.linear(.92),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: changeColor.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    hasBalanceGain
                        ? Icons.north_east_rounded
                        : Icons.south_east_rounded,
                    size: 16,
                    color: changeColor,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${hasBalanceGain ? '+' : '-'}${balanceDelta.abs().toCurrencyStringWSymbol(profile.currency)}',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: changeColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Compared with the latest recorded balance update.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF73737D),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Container(
          height: 220,
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFF9FAFF), Color(0xFFF4F6FD)],
            ),
            border: Border.all(color: const Color(0xFFE5E8F3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Balance trend',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Recent movement across your recorded balances.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: const Color(0xFF757582),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: LineChart(
                  LineChartData(
                    minY: _minY(sparklineData),
                    maxY: _maxY(sparklineData),
                    gridData: const FlGridData(show: false),
                    titlesData: const FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                    lineTouchData: const LineTouchData(enabled: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: sparklineData,
                        isCurved: true,
                        color: const Color(0xFF6271D6),
                        barWidth: 3,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              const Color(
                                0xFF6271D6,
                              ).withValues(alpha: 0.20),
                              const Color(
                                0xFF6271D6,
                              ).withValues(alpha: 0.02),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  double _minY(List<FlSpot> data) {
    final minValue = data
        .map((spot) => spot.y)
        .reduce((value, element) => math.min(value, element));
    return minValue == 0 ? -1 : minValue * 0.96;
  }

  double _maxY(List<FlSpot> data) {
    final maxValue = data
        .map((spot) => spot.y)
        .reduce((value, element) => math.max(value, element));
    return maxValue == 0 ? 1 : maxValue * 1.04;
  }
}

class _BalanceSidebar extends StatelessWidget {
  const _BalanceSidebar({
    required this.profile,
    required this.viewmodel,
    required this.appViewmodel,
    required this.delta,
  });

  final Profile profile;
  final DashboardViewmodel viewmodel;
  final AppViewmodel appViewmodel;
  final int delta;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFBFBFD),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE9E9EF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick entry',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Add income or expense without leaving the dashboard.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: const Color(0xFF74747E),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 18),
          AddTransactionButtonGroup(
            appViewmodel: appViewmodel,
            profile: profile,
            viewmodel: viewmodel,
            isWide: true,
          ),
          const SizedBox(height: 18),
          _MiniStat(
            icon: Icons.compare_arrows_rounded,
            label: 'Latest change',
            value:
                '${delta >= 0 ? '+' : '-'}${delta.abs().toCurrencyStringWSymbol(profile.currency)}',
          ),
          const SizedBox(height: 12),
          _MiniStat(
            icon: Icons.receipt_long_outlined,
            label: 'Recent activity',
            value: '${viewmodel.recentTransactions.length} transactions',
          ),
          const SizedBox(height: 12),
          _MiniStat(
            icon: Icons.account_balance_outlined,
            label: 'Accounts tracked',
            value: '${viewmodel.allLedgers.length} active',
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE8E8EE)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F3FA),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, size: 18, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF777783),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
