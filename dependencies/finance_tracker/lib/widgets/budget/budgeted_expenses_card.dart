import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:finance_tracker/app/extensions/currency.dart';
import 'package:finance_tracker/core/models/domain/account.dart';
import 'package:finance_tracker/core/models/domain/profile.dart';
import 'package:finance_tracker/viewmodels/budget_viewmodel.dart';
import 'package:finance_tracker/widgets/budget/budget_surface.dart';
import 'package:finance_tracker/widgets/shared/progress_bar.dart';
import 'package:finance_tracker/l10n/generated/app_localizations.dart';

class BudgetedExpensesCard extends StatelessWidget {
  const BudgetedExpensesCard({
    super.key,
    required this.profile,
    required this.viewmodel,
  });

  final Profile profile;
  final BudgetViewmodel viewmodel;

  @override
  Widget build(BuildContext context) {
    return BudgetSurface(
      title: AppLocalizations.of(context)!.budgetedExpenses,
      subtitle: 'Track each expense category against its planned amount.',
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          color: const Color(0xFFFBFBFD),
          border: Border.all(color: const Color(0xFFE7EAF2)),
        ),
        child: Column(
          children: [
            ...viewmodel.budget.expenses.entries.mapIndexed((index, b) {
              final Account acc = b.key;
              final int expA =
                  viewmodel.expenseTotals.entries
                      .firstWhereOrNull((e) => e.key.dbID == acc.dbID)
                      ?.value ??
                  0;
              final int expB = viewmodel.budget.expenses[acc] ?? 0;

              return Container(
                margin: EdgeInsets.only(
                  bottom: index == viewmodel.budget.expenses.length - 1
                      ? 0
                      : 12,
                ),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFE8EBF2)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        acc.name,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 5,
                      child: ProgressBar(
                        currency: profile.currency,
                        progress: (-expA).toCurrency(),
                        max: (-expB).toCurrency(),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
