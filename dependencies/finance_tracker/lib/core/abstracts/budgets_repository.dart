import 'package:finance_tracker/core/enums/budget_interval.dart';
import 'package:finance_tracker/core/models/domain/budget.dart';

abstract class BudgetsRepository {
  Future<Budget> getById(int id);
  Future<List<Budget>> getAll(int profile);
  Future<int> insertBudget(String name, String details, List<int> funds,
      Map<int, int> accounts, BudgetInterval interval, int profile);
  Future<bool> updateBudget(
      int id,
      String name,
      String details,
      List<int> funds,
      Map<int, int> accounts,
      BudgetInterval interval,
      int profile);
  Future<int> delete(int id);
}

