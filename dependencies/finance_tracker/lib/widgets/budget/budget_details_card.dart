import 'package:flutter/material.dart';
import 'package:finance_tracker/app/extensions/currency.dart';
import 'package:finance_tracker/core/models/domain/profile.dart';
import 'package:finance_tracker/viewmodels/budget_viewmodel.dart';
import 'package:finance_tracker/widgets/shared/the_divider.dart';
import 'package:finance_tracker/l10n/generated/app_localizations.dart';
import 'package:finance_tracker/widgets/budget/budget_surface.dart';

class BudgetDetailsCard extends StatelessWidget {
  const BudgetDetailsCard({
    super.key,
    required this.profile,
    required this.viewmodel,
  });

  final Profile profile;
  final BudgetViewmodel viewmodel;

  @override
  Widget build(BuildContext context) {
    return BudgetSurface(
      title: 'Budget details',
      subtitle: 'Compare actual results against expected and budgeted values.',
      child: Column(
        children: [
          _BudgetMetricRow(
            title: AppLocalizations.of(context)!.incomes,
            actual: viewmodel.aIncomeTotal.toCurrencyString(profile.currency),
            expected: viewmodel.expectedAvgInc.toCurrencyString(
              profile.currency,
            ),
            budgeted: viewmodel.bIncomeTotal.toCurrencyString(profile.currency),
            accent: const Color(0xFF2E8B57),
          ),
          const SizedBox(height: 14),
          const TheDivider(indent: 0),
          const SizedBox(height: 14),
          _BudgetMetricRow(
            title: AppLocalizations.of(context)!.expenses,
            actual: viewmodel.aExpenseTotal.toCurrencyString(profile.currency),
            expected: viewmodel.expectedAvgExp.toCurrencyString(
              profile.currency,
            ),
            budgeted: viewmodel.bExpenseTotal.toCurrencyString(
              profile.currency,
            ),
            accent: const Color(0xFFC35B5B),
          ),
          const SizedBox(height: 14),
          const TheDivider(indent: 0),
          const SizedBox(height: 14),
          _BudgetMetricRow(
            title: AppLocalizations.of(context)!.savings,
            actual: viewmodel.aDifference.toCurrencyString(profile.currency),
            expected: viewmodel.expectedAvgDif.toCurrencyString(
              profile.currency,
            ),
            budgeted: viewmodel.bDifference.toCurrencyString(profile.currency),
            accent: const Color(0xFF6271D6),
          ),
        ],
      ),
    );
  }
}

class _BudgetMetricRow extends StatelessWidget {
  const _BudgetMetricRow({
    required this.title,
    required this.actual,
    required this.expected,
    required this.budgeted,
    required this.accent,
  });

  final String title;
  final String actual;
  final String expected;
  final String budgeted;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Text(
              actual,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _BudgetValueTile(
                label: AppLocalizations.of(context)!.expected,
                value: expected,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _BudgetValueTile(
                label: AppLocalizations.of(context)!.budgeted,
                value: budgeted,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _BudgetValueTile extends StatelessWidget {
  const _BudgetValueTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFBFBFD),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE7EAF2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: const Color(0xFF777784)),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
