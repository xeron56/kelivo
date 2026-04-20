import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:finance_tracker/app/extensions/currency.dart';
import 'package:finance_tracker/viewmodels/app_viewmodel.dart';
import 'package:finance_tracker/viewmodels/budget_viewmodel.dart';
import 'package:finance_tracker/l10n/generated/app_localizations.dart';
import 'package:finance_tracker/widgets/budget/budget_surface.dart';

class BudgetPerformanceCard extends StatelessWidget {
  const BudgetPerformanceCard({
    super.key,
    required this.appViewmodel,
    required this.viewmodel,
  });

  final AppViewmodel appViewmodel;
  final BudgetViewmodel viewmodel;

  @override
  Widget build(BuildContext context) {
    return BudgetSurface(
      title: AppLocalizations.of(context)!.budgetPerformance,
      subtitle: 'See how actual income and expenses are tracking against plan.',
      child: Container(
        height: 230,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF9FAFF), Color(0xFFF4F6FD)],
          ),
          border: Border.all(color: const Color(0xFFE6EAF2)),
        ),
        child: Row(
          children: [
            if (viewmodel.incomeTotals.isNotEmpty)
              Expanded(
                child: PieChart(
                  duration: const Duration(microseconds: 1500),
                  PieChartData(
                    sectionsSpace: 1,
                    startDegreeOffset: 180,
                    centerSpaceRadius: 26,
                    sections: [
                      PieChartSectionData(
                        title:
                            "${AppLocalizations.of(context)!.incomes}\n${((viewmodel.aIncomeTotal / viewmodel.bIncomeTotal) * 100).round()}%",
                        titleStyle: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        color: appViewmodel.receiptColor,
                        radius: 74,
                        value: viewmodel.aIncomeTotal.abs().toCurrency(),
                      ),
                      if (viewmodel.aIncomeTotal.abs() <
                          viewmodel.bIncomeTotal.abs())
                        PieChartSectionData(
                          title: "",
                          color: Colors.grey.withAlpha(90),
                          radius: 74,
                          value:
                              (viewmodel.bIncomeTotal.abs() -
                                      viewmodel.aIncomeTotal.abs())
                                  .abs()
                                  .toCurrency(),
                        ),
                    ],
                  ),
                ),
              ),
            if (viewmodel.expenseTotals.isNotEmpty)
              Expanded(
                child: PieChart(
                  duration: const Duration(microseconds: 1500),
                  PieChartData(
                    sectionsSpace: 1,
                    startDegreeOffset: 180,
                    centerSpaceRadius: 26,
                    sections: [
                      PieChartSectionData(
                        title:
                            "${AppLocalizations.of(context)!.expenses}\n${((viewmodel.aExpenseTotal / viewmodel.bExpenseTotal) * 100).round()}%",
                        titleStyle: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        color: appViewmodel.paymentColor,
                        radius: 74,
                        value: viewmodel.aExpenseTotal.abs().toCurrency(),
                      ),
                      if (viewmodel.aExpenseTotal.abs() <
                          viewmodel.bExpenseTotal.abs())
                        PieChartSectionData(
                          title: "",
                          color: Colors.grey.withAlpha(90),
                          radius: 74,
                          value:
                              (viewmodel.bExpenseTotal -
                                      viewmodel.aExpenseTotal)
                                  .abs()
                                  .toCurrency(),
                        ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
