import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:finance_tracker/app/global/dimensions.dart';
import 'package:finance_tracker/app/extensions/currency.dart';
import 'package:finance_tracker/core/enums/loading_status.dart';
import 'package:finance_tracker/core/models/domain/profile.dart';
import 'package:finance_tracker/core/repositories/drift/budgets_drift_repository.dart';
import 'package:finance_tracker/screens/budget_entry_screen.dart';
import 'package:finance_tracker/screens/budget_screen.dart';
import 'package:finance_tracker/viewmodels/budgets_viewmodel.dart';
import 'package:finance_tracker/widgets/shared/empty_list.dart';
import 'package:finance_tracker/widgets/shared/loading_body.dart';
import 'package:finance_tracker/widgets/shared/search_field.dart';
import 'package:finance_tracker/l10n/generated/app_localizations.dart';
import 'package:finance_tracker/widgets/shared/the_divider.dart';

class BudgetsScreen extends StatelessWidget {
  const BudgetsScreen({
    super.key,
    required this.profile,
    this.accType,
  });
  final Profile profile;
  final int? accType;

  @override
  Widget build(BuildContext context) {
    final budgetsDriftRepository =
        Provider.of<BudgetsDriftRepository>(context, listen: false);
    return ChangeNotifierProvider<BudgetsViewmodel>(
      create: (context) => BudgetsViewmodel(
        budgetsDriftRepository,
        profile: profile,
      )..init(),
      builder: (context, child) => Scaffold(
        backgroundColor: const Color(0xFFF7F7FA),
        appBar: AppBar(),
        body: Consumer<BudgetsViewmodel>(
          builder: (context, viewmodel, child) {
            return LoadingBody(
              loadingStatus: viewmodel.loadingStatus,
              errorText: viewmodel.errorText,
              resetErrorTextFn: () {
                viewmodel.resetErrorText();
              },
              widget: LayoutBuilder(
                builder: (context, constraints) {
                  bool isWide = constraints.maxWidth > 800;

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: BudgetsList(
                          viewmodel: viewmodel,
                          isWide: isWide,
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            final provider =
                Provider.of<BudgetsViewmodel>(context, listen: false);

            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BudgetEntryScreen(
                    profile: profile,
                  ),
                )).then((_) {
              provider.init();
            });
          },
          heroTag: "addBudget",
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class BudgetsList extends StatelessWidget {
  const BudgetsList({
    super.key,
    required this.viewmodel,
    required this.isWide,
  });

  final BudgetsViewmodel viewmodel;
  final bool isWide;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final totalIncome = viewmodel.fBudgets.fold<double>(
      0,
      (sum, budget) => sum + budget.incomes.values.sum,
    );
    final totalExpense = viewmodel.fBudgets.fold<double>(
      0,
      (sum, budget) => sum + budget.expenses.values.sum,
    );
    final totalSavings = totalIncome + totalExpense;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1160),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: const Color(0xFFE7E7EC)),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0A000000),
                      blurRadius: 26,
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
                            Icons.savings_rounded,
                            color: theme.colorScheme.primary,
                            size: 28,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.myBudgets,
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Track recurring plans, compare spending targets, and open each budget for a detailed performance view.',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.textTheme.bodySmall?.color
                                    ?.withValues(alpha: 0.78),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: viewmodel.headerHeight,
                      curve: Curves.easeInOut,
                      child: SearchField(searchFn: (term) {
                        viewmodel.searchTerm = term;
                      }),
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _BudgetMetricChip(
                          label: l10n.budgets,
                          value: '${viewmodel.fBudgets.length}',
                          icon: Icons.dashboard_customize_rounded,
                        ),
                        _BudgetMetricChip(
                          label: l10n.incomes,
                          value: totalIncome.toCurrencyString(
                            viewmodel.profile.currency,
                          ),
                          icon: Icons.trending_up_rounded,
                          accent: const Color(0xFFEEF7EE),
                        ),
                        _BudgetMetricChip(
                          label: l10n.expenses,
                          value: totalExpense.toCurrencyString(
                            viewmodel.profile.currency,
                          ),
                          icon: Icons.receipt_long_rounded,
                          accent: const Color(0xFFFFF2EF),
                        ),
                        _BudgetMetricChip(
                          label: l10n.savings,
                          value: totalSavings.toCurrencyString(
                            viewmodel.profile.currency,
                          ),
                          icon: Icons.stacked_line_chart_rounded,
                          accent: const Color(0xFFF4F2FF),
                          valueColor: totalSavings < 0
                              ? const Color(0xFFB42318)
                              : theme.colorScheme.primary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: viewmodel.fBudgets.isEmpty,
              child: Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: const Color(0xFFE7E7EC)),
                    ),
                    child: EmptyList(
                      items: l10n.budgets,
                      addFn: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  BudgetEntryScreen(profile: viewmodel.profile),
                            )).then((_) {
                          viewmodel.init();
                        });
                      },
                      isListFiltered: viewmodel.budgets.isNotEmpty ||
                          (viewmodel.budgets.isNotEmpty &&
                              viewmodel.fBudgets.length ==
                                  viewmodel.budgets.length),
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: viewmodel.fBudgets.isNotEmpty,
              child: Expanded(child: Builder(builder: (_) {
                if (viewmodel.searchLoadingStatus == LoadingStatus.completed) {
                  return ListView.builder(
                    controller: viewmodel.scrollController,
                    itemCount: viewmodel.fBudgets.length,
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                    itemBuilder: (context, index) {
                      final b = viewmodel.fBudgets[index];
                      final incomeTotal = b.incomes.values.sum;
                      final expenseTotal = b.expenses.values.sum;
                      final difference = incomeTotal + expenseTotal;
                      final budgetItems =
                          b.incomes.length + b.expenses.length;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: SizedBox(
                          width: cardWidth,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(26),
                              border: Border.all(
                                color: const Color(0xFFE7E7EC),
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x08000000),
                                  blurRadius: 24,
                                  offset: Offset(0, 10),
                                ),
                              ],
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(26),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BudgetScreen(
                                        profile: viewmodel.profile,
                                        budget: b,
                                      ),
                                    )).then((_) => viewmodel.init());
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(22),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                b.name,
                                                style: theme
                                                    .textTheme.headlineSmall
                                                    ?.copyWith(
                                                  fontWeight: FontWeight.w800,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              if (b.details.isNotEmpty) ...[
                                                const SizedBox(height: 8),
                                                Text(
                                                  b.details,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: theme
                                                      .textTheme.bodyMedium
                                                      ?.copyWith(
                                                    color: theme.textTheme
                                                        .bodySmall?.color
                                                        ?.withValues(
                                                          alpha: 0.76,
                                                        ),
                                                    height: 1.35,
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF5F6FB),
                                            borderRadius:
                                                BorderRadius.circular(14),
                                          ),
                                          child: Text(
                                            b.interval.label,
                                            overflow: TextOverflow.ellipsis,
                                            style: theme.textTheme.labelLarge
                                                ?.copyWith(
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 18),
                                    Wrap(
                                      spacing: 10,
                                      runSpacing: 10,
                                      children: [
                                        _BudgetTag(
                                          icon: Icons.account_balance_wallet,
                                          label:
                                              '$budgetItems planned item${budgetItems == 1 ? '' : 's'}',
                                        ),
                                        _BudgetTag(
                                          icon: Icons.wallet_outlined,
                                          label:
                                              '${b.funds.length} tracked fund${b.funds.length == 1 ? '' : 's'}',
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    const TheDivider(indent: 0),
                                    const SizedBox(height: 14),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _BudgetValueColumn(
                                            label: l10n.incomes,
                                            value: incomeTotal
                                                .toCurrencyString(
                                                    viewmodel.profile.currency),
                                            accent: const Color(0xFF2F7A4A),
                                          ),
                                        ),
                                        Expanded(
                                          child: _BudgetValueColumn(
                                            label: l10n.expenses,
                                            value: expenseTotal
                                                .toCurrencyString(
                                                    viewmodel.profile.currency),
                                            accent: const Color(0xFFB54708),
                                          ),
                                        ),
                                        Expanded(
                                          child: _BudgetValueColumn(
                                            label: l10n.savings,
                                            value: difference.toCurrencyString(
                                                viewmodel.profile.currency),
                                            accent: difference < 0
                                                ? const Color(0xFFB42318)
                                                : theme.colorScheme.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                            .animate(delay: 100.ms)
                            .scale(
                                begin: const Offset(1.02, 1.02),
                                duration: 100.ms)
                            .fade(curve: Curves.easeInOut, duration: 100.ms),
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              })),
            )
          ],
        ),
      ),
    );
  }
}

class _BudgetMetricChip extends StatelessWidget {
  const _BudgetMetricChip({
    required this.label,
    required this.value,
    required this.icon,
    this.accent = const Color(0xFFF5F6FB),
    this.valueColor,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color accent;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      constraints: const BoxConstraints(minWidth: 180),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: accent,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: theme.colorScheme.primary),
          const SizedBox(width: 10),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.textTheme.bodySmall?.color
                        ?.withValues(alpha: 0.74),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: valueColor,
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

class _BudgetTag extends StatelessWidget {
  const _BudgetTag({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8FC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEAEAF0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _BudgetValueColumn extends StatelessWidget {
  const _BudgetValueColumn({
    required this.label,
    required this.value,
    required this.accent,
  });

  final String label;
  final String value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.74),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: accent,
          ),
        ),
      ],
    );
  }
}

