import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:finance_tracker/app/extensions/currency.dart';
import 'package:finance_tracker/app/global/dimensions.dart';
import 'package:finance_tracker/core/enums/currency.dart';
import 'package:finance_tracker/core/models/domain/account.dart';
import 'package:finance_tracker/l10n/generated/app_localizations.dart';
import 'package:finance_tracker/viewmodels/insights_viewmodel.dart';
import 'package:finance_tracker/widgets/shared/progress_bar.dart';

class BudgetBarChartCard extends StatelessWidget {
  const BudgetBarChartCard({
    super.key,
    required this.viewmodel,
  });

  final InsightsViewmodel viewmodel;

  @override
  Widget build(BuildContext context) {
    final budget = viewmodel.selectedBudget;

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
                          AppLocalizations.of(context)!.budgetedExpenses,
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w800,
                                  ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Compare actual category spending against your active budget.',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: const Color(0xFF6B6B80),
                                  ),
                        ),
                      ],
                    ),
                  ),
                  if (budget != null)
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
                            'Interval',
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(color: const Color(0xFF747488)),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            budget.interval.label,
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              if (viewmodel.budgets.length > 1) ...[
                const SizedBox(height: 18),
                DropdownMenu(
                  enableSearch: false,
                  width: cardWidth,
                  label: Text(AppLocalizations.of(context)!.myBudgets),
                  initialSelection: viewmodel.selectedBudget,
                  onSelected: (selectedBudget) {
                    viewmodel.selectedBudget = selectedBudget;
                  },
                  dropdownMenuEntries: [
                    ...viewmodel.budgets.map(
                      (entry) => DropdownMenuEntry(
                        value: entry,
                        label: entry.name,
                        trailingIcon: Text(entry.interval.label),
                      ),
                    ),
                  ],
                ),
              ],
              if (budget != null) ...[
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F8FC),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: const Color(0xFFE7E7EC)),
                  ),
                  child: Column(
                    children: [
                      ...budget.expenses.entries.mapIndexed((index, entry) {
                        final account = entry.key;
                        final actualSpent = viewmodel.expenseTotals.entries
                                .firstWhereOrNull(
                                  (expenseEntry) =>
                                      expenseEntry.key.dbID == account.dbID,
                                )
                                ?.value ??
                            0;
                        final budgeted = budget.expenses[account] ?? 0;

                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: index == budget.expenses.length - 1 ? 0 : 14,
                          ),
                          child: _BudgetRow(
                            account: account,
                            spent: actualSpent,
                            budgeted: budgeted,
                            currency: viewmodel.selectedProfile.currency,
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    )
        .animate(delay: 200.ms)
        .scale(begin: const Offset(1.02, 1.02), duration: 120.ms)
        .fade(curve: Curves.easeInOut, duration: 120.ms);
  }
}

class _BudgetRow extends StatelessWidget {
  const _BudgetRow({
    required this.account,
    required this.spent,
    required this.budgeted,
    required this.currency,
  });

  final Account account;
  final int spent;
  final int budgeted;
  final Currency currency;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE7E7EC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  account.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                (-spent).toCurrencyStringWSymbol(currency),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ProgressBar(
            currency: currency,
            progress: (-spent).toCurrency(),
            max: (-budgeted).toCurrency(),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Budget ${(-budgeted).toCurrencyStringWSymbol(currency)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF6B6B80),
                    ),
              ),
              Text(
                budgeted == 0
                    ? 'No limit'
                    : '${(((-spent) / (-budgeted)) * 100).clamp(0, 999).toStringAsFixed(0)}%',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF6B6B80),
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
