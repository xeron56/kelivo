import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:finance_tracker/app/global/dimensions.dart';
import 'package:finance_tracker/core/enums/app_date_format.dart';
import 'package:finance_tracker/core/enums/date_filter_type.dart';
import 'package:finance_tracker/core/enums/loading_status.dart';
import 'package:finance_tracker/core/models/domain/profile.dart';
import 'package:finance_tracker/core/repositories/drift/accounts_drift_repository.dart';
import 'package:finance_tracker/core/repositories/drift/balances_drift_repository.dart';
import 'package:finance_tracker/core/repositories/drift/budgets_drift_repository.dart';
import 'package:finance_tracker/core/repositories/drift/profiles_drift_repository.dart';
import 'package:finance_tracker/core/repositories/drift/transactions_drift_repository.dart';
import 'package:finance_tracker/l10n/generated/app_localizations.dart';
import 'package:finance_tracker/viewmodels/app_viewmodel.dart';
import 'package:finance_tracker/viewmodels/insights_viewmodel.dart';
import 'package:finance_tracker/widgets/insights/average_transactions_bar_chart_card.dart';
import 'package:finance_tracker/widgets/insights/budget_bar_chart_card.dart';
import 'package:finance_tracker/widgets/insights/daily_tranactions_bar_chart_card.dart';
import 'package:finance_tracker/widgets/insights/expenses_split_pie_chart_card.dart';
import 'package:finance_tracker/widgets/insights/fund_balances_line_chart_card.dart';
import 'package:finance_tracker/widgets/shared/loading_body.dart';
import 'package:finance_tracker/widgets/shared/the_date_picker.dart';

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key, required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    final profilesDriftRepository = Provider.of<ProfilesDriftRepository>(
      context,
      listen: false,
    );
    final accountsDriftRepository = Provider.of<AccountsDriftRepository>(
      context,
      listen: false,
    );
    final transactionsDriftRepository =
        Provider.of<TransactionsDriftRepository>(context, listen: false);
    final balancesDriftRepository = Provider.of<BalancesDriftRepository>(
      context,
      listen: false,
    );
    final budgetsDriftRepository = Provider.of<BudgetsDriftRepository>(
      context,
      listen: false,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FA),
      body: ChangeNotifierProvider(
        create: (context) => InsightsViewmodel(
          profilesDriftRepository,
          accountsDriftRepository,
          transactionsDriftRepository,
          balancesDriftRepository,
          budgetsDriftRepository,
          profile: profile,
        )..init(),
        builder: (context, child) => Consumer<InsightsViewmodel>(
          builder: (context, viewmodel, child) => LoadingBody(
            loadingStatus: viewmodel.loadingStatus,
            resetErrorTextFn: () {
              viewmodel.resetErrorText();
            },
            errorText: viewmodel.errorText,
            widget: InsightsList(viewmodel: viewmodel),
          ),
        ),
      ),
    );
  }
}

class InsightsList extends StatelessWidget {
  const InsightsList({super.key, required this.viewmodel});

  final InsightsViewmodel viewmodel;

  @override
  Widget build(BuildContext context) {
    final appViewmodel = Provider.of<AppViewmodel>(context);
    final localizations = AppLocalizations.of(context)!;

    return LayoutBuilder(
      builder: (context, constraints) {
        final contentWidth = constraints.maxWidth > 1320
            ? 1320.0
            : constraints.maxWidth;
        final hasInsights = viewmodel.transactions.isNotEmpty;
        final chartWidgets = <Widget>[
          if (viewmodel.expenseTotals.entries.isNotEmpty)
            ExpensesSplitPieChartCard(viewmodel: viewmodel),
          if (viewmodel.dailyTotalTransactions.length > 1)
            DailyTransactionsBarChartCard(viewmodel: viewmodel),
          if (viewmodel.fundBalances.isNotEmpty &&
              viewmodel.fundBalances.values.first.length > 1)
            FundBalancesLineChartCard(viewmodel: viewmodel),
          if (viewmodel.selectedBudget != null)
            BudgetBarChartCard(viewmodel: viewmodel),
          if (viewmodel.weeklyAvgExpenses.isNotEmpty &&
              viewmodel.dateFilterType.index > 1 &&
              viewmodel.weeklyAvgExpenses.values.first.isNotEmpty &&
              viewmodel.dailyTotalTransactions.length > 14)
            AverageTransactionsBarChartCard(viewmodel: viewmodel),
        ];

        return SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: contentWidth,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
                children: [
                  _InsightsHero(
                    viewmodel: viewmodel,
                    rangeLabel: _buildRangeLabel(
                      context,
                      viewmodel,
                      appViewmodel.dateFormat.pattern ??
                          AppDateFormat.date1.pattern,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _FilterCard(
                    child: _DateFilterBar(
                      viewmodel: viewmodel,
                      appViewmodel: appViewmodel,
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (!hasInsights)
                    _EmptyInsightsCard(label: localizations.notEnoughData)
                  else if (viewmodel.calculationStatus == LoadingStatus.loading)
                    const _CalculatingInsightsCard()
                  else
                    ..._buildChartSections(chartWidgets, contentWidth),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildChartSections(List<Widget> chartWidgets, double contentWidth) {
    if (chartWidgets.isEmpty) {
      return const [];
    }

    final isTwoColumn = contentWidth >= (cardWidth * 2) + 32;
    if (!isTwoColumn) {
      return [
        for (var index = 0; index < chartWidgets.length; index++) ...[
          chartWidgets[index],
          if (index != chartWidgets.length - 1) const SizedBox(height: 20),
        ],
      ];
    }

    final rows = <Widget>[];
    for (var index = 0; index < chartWidgets.length; index += 2) {
      rows.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: chartWidgets[index]),
            const SizedBox(width: 20),
            Expanded(
              child: index + 1 < chartWidgets.length
                  ? chartWidgets[index + 1]
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      );

      if (index + 2 < chartWidgets.length) {
        rows.add(const SizedBox(height: 20));
      }
    }

    return rows;
  }

  String _buildRangeLabel(
    BuildContext context,
    InsightsViewmodel viewmodel,
    String datePattern,
  ) {
    final localizations = MaterialLocalizations.of(context);
    if (viewmodel.dateFilterType != DateFilterType.custom) {
      return viewmodel.dateFilterType.label;
    }

    final start = localizations.formatShortDate(viewmodel.startDate);
    final end = localizations.formatShortDate(viewmodel.endDate);
    return '$start - $end';
  }
}

class _InsightsHero extends StatelessWidget {
  const _InsightsHero({required this.viewmodel, required this.rangeLabel});

  final InsightsViewmodel viewmodel;
  final String rangeLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chartCount = [
      viewmodel.expenseTotals.entries.isNotEmpty,
      viewmodel.dailyTotalTransactions.length > 1,
      viewmodel.fundBalances.isNotEmpty &&
          viewmodel.fundBalances.values.firstOrNull?.length != null &&
          viewmodel.fundBalances.values.first.length > 1,
      viewmodel.selectedBudget != null,
      viewmodel.weeklyAvgExpenses.isNotEmpty &&
          viewmodel.weeklyAvgExpenses.values.firstOrNull?.isNotEmpty == true &&
          viewmodel.dailyTotalTransactions.length > 14,
    ].where((value) => value).length;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFE7E7EC)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 30,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 16,
            runSpacing: 16,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4FF),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(
                  Icons.insights_rounded,
                  color: theme.colorScheme.primary,
                  size: 28,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.myInsights,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Track spending patterns, balances, and budget pressure in one place.',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: const Color(0xFF66667A),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _HeroMetricChip(
                icon: Icons.calendar_today_rounded,
                label: 'Active range',
                value: rangeLabel,
              ),
              _HeroMetricChip(
                icon: Icons.account_balance_wallet_rounded,
                label: 'Expense groups',
                value: '${viewmodel.expenseTotals.length}',
              ),
              _HeroMetricChip(
                icon: Icons.show_chart_rounded,
                label: 'Insight cards',
                value: '$chartCount',
              ),
              _HeroMetricChip(
                icon: Icons.timeline_rounded,
                label: 'Tracked days',
                value: '${viewmodel.dailyTotalTransactions.length}',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DateFilterBar extends StatelessWidget {
  const _DateFilterBar({required this.viewmodel, required this.appViewmodel});

  final InsightsViewmodel viewmodel;
  final AppViewmodel appViewmodel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.dates,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Change the time window to refresh every chart below.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: const Color(0xFF6C6C80),
          ),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ...DateFilterType.values.map(
                (filterType) => Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: FilterChip(
                    selected: viewmodel.dateFilterType == filterType,
                    showCheckmark: false,
                    label: Text(filterType.label),
                    selectedColor: theme.colorScheme.primary.withAlpha(24),
                    backgroundColor: const Color(0xFFF8F8FC),
                    side: BorderSide(
                      color: viewmodel.dateFilterType == filterType
                          ? theme.colorScheme.primary.withAlpha(80)
                          : const Color(0xFFE2E3EA),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    onSelected: (_) async {
                      if (viewmodel.calculationStatus == LoadingStatus.loading) {
                        return;
                      }
                      viewmodel.dateFilterType = filterType;
                      if (filterType == DateFilterType.custom) {
                        await _openCustomDateDialog(context);
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _openCustomDateDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 24,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)?.dates ?? 'Dates',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Choose the exact reporting window for your insights.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF6C6C80),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: cardWidth,
                    child: TheDatePicker(
                      initialDate: viewmodel.startDate,
                      onChanged: (date) async {
                        await viewmodel.addToFilter(sDate: date);
                        setState(() {});
                      },
                      label:
                          AppLocalizations.of(context)?.startDate ??
                          'Start Date',
                      needTime: false,
                      datePattern:
                          appViewmodel.dateFormat.pattern ??
                          AppDateFormat.date1.pattern,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: cardWidth,
                    child: TheDatePicker(
                      initialDate: viewmodel.endDate,
                      onChanged: (date) async {
                        await viewmodel.addToFilter(eDate: date);
                        setState(() {});
                      },
                      label:
                          AppLocalizations.of(context)?.endDate ?? 'End Date',
                      needTime: false,
                      datePattern:
                          appViewmodel.dateFormat.pattern ??
                          AppDateFormat.date1.pattern,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        AppLocalizations.of(context)?.save ?? 'Save',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _FilterCard extends StatelessWidget {
  const _FilterCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE7E7EC)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _CalculatingInsightsCard extends StatelessWidget {
  const _CalculatingInsightsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFE7E7EC)),
      ),
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}

class _EmptyInsightsCard extends StatelessWidget {
  const _EmptyInsightsCard({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFE7E7EC)),
      ),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: const Color(0xFFF4F5FB),
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Icon(Icons.analytics_outlined, size: 34),
          ),
          const SizedBox(height: 20),
          Text(
            label,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Add more transactions or widen the date range to unlock charts and trends.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF6C6C80),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _HeroMetricChip extends StatelessWidget {
  const _HeroMetricChip({
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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8FC),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE6E7EE)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: theme.colorScheme.primary),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: const Color(0xFF77778A),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
