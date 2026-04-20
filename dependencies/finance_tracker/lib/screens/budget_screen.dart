import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:finance_tracker/app/extensions/currency.dart';
import 'package:finance_tracker/core/models/domain/budget.dart';
import 'package:finance_tracker/core/models/domain/profile.dart';
import 'package:finance_tracker/core/repositories/drift/accounts_drift_repository.dart';
import 'package:finance_tracker/core/repositories/drift/budgets_drift_repository.dart';
import 'package:finance_tracker/core/repositories/drift/transactions_drift_repository.dart';
import 'package:finance_tracker/screens/budget_entry_screen.dart';
import 'package:finance_tracker/viewmodels/app_viewmodel.dart';
import 'package:finance_tracker/viewmodels/budget_viewmodel.dart';
import 'package:finance_tracker/widgets/budget/budget_details_card.dart';
import 'package:finance_tracker/widgets/budget/budget_performance_card.dart';
import 'package:finance_tracker/widgets/budget/budgeted_expenses_card.dart';
import 'package:finance_tracker/widgets/budget/income_vs_expense_card.dart';
import 'package:finance_tracker/widgets/shared/acc_type_icon.dart';
import 'package:finance_tracker/widgets/shared/loading_body.dart';
import 'package:finance_tracker/l10n/generated/app_localizations.dart';

class BudgetScreen extends StatelessWidget {
  const BudgetScreen({super.key, required this.profile, required this.budget});
  final Profile profile;
  final Budget budget;

  @override
  Widget build(BuildContext context) {
    final accountsDriftRepository =
        Provider.of<AccountsDriftRepository>(context, listen: false);
    final budgetsDriftRepository =
        Provider.of<BudgetsDriftRepository>(context, listen: false);
    final transactionsDriftRepository =
        Provider.of<TransactionsDriftRepository>(context, listen: false);

    final appViewmodel = Provider.of<AppViewmodel>(context);
    return ChangeNotifierProvider<BudgetViewmodel>(
      create: (context) => BudgetViewmodel(accountsDriftRepository,
          budgetsDriftRepository, transactionsDriftRepository,
          profile: profile, budget: budget)
        ..init(),
      builder: (context, child) => Consumer<BudgetViewmodel>(
        builder: (context, viewmodel, child) {
          final totalIncome = viewmodel.budget.incomes.values.sum;
          final totalExpense = viewmodel.budget.expenses.values.sum;
          final totalSavings = totalIncome + totalExpense;
          final totalTracked = viewmodel.budget.funds.length;
          final theme = Theme.of(context);

          return Scaffold(
            backgroundColor: const Color(0xFFF7F7FA),
            appBar: AppBar(
              backgroundColor: const Color(0xFFF7F7FA),
              surfaceTintColor: Colors.transparent,
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BudgetEntryScreen(
                              profile: profile,
                              budget: viewmodel.budget,
                            ),
                          )).then((_) => viewmodel.refetchBudget());
                    },
                    icon: const Icon(Icons.edit)),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        content: Text(
                            AppLocalizations.of(context)!.deleteBudgetWarning),
                        actions: [
                          TextButton(
                              onPressed: () async {
                                final hasDeleted =
                                    await viewmodel.deleteBudget();
                                if (hasDeleted && context.mounted) {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                }
                              },
                              child: Text(
                                AppLocalizations.of(context)!.delete,
                                style: const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                              )),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(AppLocalizations.of(context)!.cancel))
                        ],
                        title: Text(
                            AppLocalizations.of(context)!.deleteThisBudgetQn),
                      ),
                    );
                  },
                  icon: const Icon(Icons.delete),
                  color: Colors.red,
                ),
                const SizedBox(
                  width: 12,
                )
              ],
            ),
            body: LoadingBody(
                loadingStatus: viewmodel.loadingStatus,
                errorText: viewmodel.errorText,
                widget: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1200),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(28),
                              border: Border.all(
                                color: const Color(0xFFE7E7EC),
                              ),
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
                                  crossAxisAlignment:
                                      WrapCrossAlignment.center,
                                  children: [
                                    Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF3F4FF),
                                        borderRadius:
                                            BorderRadius.circular(20),
                                      ),
                                      child: Icon(
                                        Icons.savings_outlined,
                                        color: theme.colorScheme.primary,
                                        size: 30,
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            viewmodel.budget.name,
                                            overflow: TextOverflow.ellipsis,
                                            style: theme
                                                .textTheme.headlineMedium
                                                ?.copyWith(
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                          if (viewmodel.budget.details
                                              .isNotEmpty) ...[
                                            const SizedBox(height: 8),
                                            Text(
                                              viewmodel.budget.details,
                                              style: theme.textTheme.titleMedium
                                                  ?.copyWith(
                                                color: theme.textTheme.bodySmall
                                                    ?.color
                                                    ?.withValues(alpha: 0.8),
                                                height: 1.35,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF5F6FB),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Text(
                                        viewmodel.budget.interval.label,
                                        overflow: TextOverflow.ellipsis,
                                        style: theme.textTheme.titleSmall
                                            ?.copyWith(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                Wrap(
                                  spacing: 12,
                                  runSpacing: 12,
                                  children: [
                                    _BudgetSummaryPill(
                                      label:
                                          AppLocalizations.of(context)!.incomes,
                                      value: totalIncome.toCurrencyString(
                                        profile.currency,
                                      ),
                                      icon: Icons.trending_up_rounded,
                                      accent: const Color(0xFFEEF7EE),
                                      valueColor: const Color(0xFF2F7A4A),
                                    ),
                                    _BudgetSummaryPill(
                                      label: AppLocalizations.of(context)!
                                          .expenses,
                                      value: totalExpense.toCurrencyString(
                                        profile.currency,
                                      ),
                                      icon: Icons.receipt_long_rounded,
                                      accent: const Color(0xFFFFF2EF),
                                      valueColor: const Color(0xFFB54708),
                                    ),
                                    _BudgetSummaryPill(
                                      label:
                                          AppLocalizations.of(context)!.savings,
                                      value: totalSavings.toCurrencyString(
                                        profile.currency,
                                      ),
                                      icon: Icons.stacked_line_chart_rounded,
                                      accent: const Color(0xFFF4F2FF),
                                      valueColor: totalSavings < 0
                                          ? const Color(0xFFB42318)
                                          : theme.colorScheme.primary,
                                    ),
                                    _BudgetSummaryPill(
                                      label: 'Tracked funds',
                                      value: '$totalTracked',
                                      icon:
                                          Icons.account_balance_wallet_outlined,
                                      accent: const Color(0xFFF6F7FB),
                                    ),
                                  ],
                                ),
                                if (viewmodel.budget.funds.isNotEmpty) ...[
                                  const SizedBox(height: 24),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(18),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF9F9FC),
                                      borderRadius: BorderRadius.circular(22),
                                      border: Border.all(
                                        color: const Color(0xFFEAEAF0),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Tracked funds',
                                          style: theme.textTheme.titleMedium
                                              ?.copyWith(
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          'Accounts included in this budget for live monitoring and reporting.',
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                            color: theme
                                                .textTheme.bodySmall?.color
                                                ?.withValues(alpha: 0.78),
                                          ),
                                        ),
                                        const SizedBox(height: 14),
                                        Wrap(
                                          spacing: 8,
                                          runSpacing: 8,
                                          children:
                                              viewmodel.budget.funds.map((f) {
                                            return Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 10,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                border: Border.all(
                                                  color:
                                                      const Color(0xFFE7E7EC),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Container(
                                                    width: 30,
                                                    height: 30,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          theme.colorScheme.primary,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: Icon(
                                                      getAccTypeIcon(
                                                          f.accountType),
                                                      size: 16,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Text(
                                                    f.name,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: theme
                                                        .textTheme.bodyMedium
                                                        ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          LayoutBuilder(
                            builder: (context, constraints) {
                              final isWide = constraints.maxWidth >= 1040;
                              if (isWide) {
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          BudgetDetailsCard(
                                            profile: profile,
                                            viewmodel: viewmodel,
                                          )
                                              .animate(delay: 0.ms)
                                              .scale(
                                                  begin:
                                                      const Offset(1.02, 1.02),
                                                  duration: 100.ms)
                                              .fade(
                                                  curve: Curves.easeInOut,
                                                  duration: 100.ms),
                                          const SizedBox(height: 20),
                                          IncomeVsExpenseCard(
                                            appViewmodel: appViewmodel,
                                            viewmodel: viewmodel,
                                          )
                                              .animate(delay: 100.ms)
                                              .scale(
                                                  begin:
                                                      const Offset(1.02, 1.02),
                                                  duration: 100.ms)
                                              .fade(
                                                  curve: Curves.easeInOut,
                                                  duration: 100.ms),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          BudgetPerformanceCard(
                                            appViewmodel: appViewmodel,
                                            viewmodel: viewmodel,
                                          )
                                              .animate(delay: 50.ms)
                                              .scale(
                                                  begin:
                                                      const Offset(1.02, 1.02),
                                                  duration: 100.ms)
                                              .fade(
                                                  curve: Curves.easeInOut,
                                                  duration: 100.ms),
                                          const SizedBox(height: 20),
                                          BudgetedExpensesCard(
                                            profile: profile,
                                            viewmodel: viewmodel,
                                          )
                                              .animate(delay: 150.ms)
                                              .scale(
                                                  begin:
                                                      const Offset(1.02, 1.02),
                                                  duration: 100.ms)
                                              .fade(
                                                  curve: Curves.easeInOut,
                                                  duration: 100.ms),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              }

                              return Column(
                                children: [
                                  BudgetDetailsCard(
                                    profile: profile,
                                    viewmodel: viewmodel,
                                  )
                                      .animate(delay: 0.ms)
                                      .scale(
                                          begin: const Offset(1.02, 1.02),
                                          duration: 100.ms)
                                      .fade(
                                          curve: Curves.easeInOut,
                                          duration: 100.ms),
                                  const SizedBox(height: 20),
                                  BudgetPerformanceCard(
                                    appViewmodel: appViewmodel,
                                    viewmodel: viewmodel,
                                  )
                                      .animate(delay: 50.ms)
                                      .scale(
                                          begin: const Offset(1.02, 1.02),
                                          duration: 100.ms)
                                      .fade(
                                          curve: Curves.easeInOut,
                                          duration: 100.ms),
                                  const SizedBox(height: 20),
                                  IncomeVsExpenseCard(
                                    appViewmodel: appViewmodel,
                                    viewmodel: viewmodel,
                                  )
                                      .animate(delay: 100.ms)
                                      .scale(
                                          begin: const Offset(1.02, 1.02),
                                          duration: 100.ms)
                                      .fade(
                                          curve: Curves.easeInOut,
                                          duration: 100.ms),
                                  const SizedBox(height: 20),
                                  BudgetedExpensesCard(
                                    profile: profile,
                                    viewmodel: viewmodel,
                                  )
                                      .animate(delay: 150.ms)
                                      .scale(
                                          begin: const Offset(1.02, 1.02),
                                          duration: 100.ms)
                                      .fade(
                                          curve: Curves.easeInOut,
                                          duration: 100.ms),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                resetErrorTextFn: () {
                  viewmodel.resetErrorText();
                }),
          );
        },
      ),
    );
  }
}

class _BudgetSummaryPill extends StatelessWidget {
  const _BudgetSummaryPill({
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
      constraints: const BoxConstraints(minWidth: 190),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: accent,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: theme.colorScheme.primary, size: 18),
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
