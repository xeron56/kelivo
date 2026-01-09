import 'package:drift/drift.dart';
import 'package:finance_tracker/core/abstracts/balances_repository.dart';
import 'package:finance_tracker/core/db/app_drift_database.dart';
import 'package:finance_tracker/utils/app_logger.dart';

class BalancesDriftRepository implements BalancesRepository {
  BalancesDriftRepository(this.db);
  final AppDriftDatabase db;

  @override
  Future<int> insertBalance({required int account, required int amount}) async {
    try {
      final balance = DriftBalancesCompanion(
          account: Value(account), amount: Value(amount));
      return await db.insertBalance(balance);
    } catch (e) {
      AppLogger.instance.error("Failed to insert balance. ${e.toString()}");
      rethrow;
    }
  }

  @override
  Future<bool> updateBalanceByAccount({required int account}) async {
    try {
      final amount = await db.calculateBalance(account);
      final balance = await db.getBalanceByAccount(account);
      final newBal = DriftBalancesCompanion(
          account: Value(account),
          amount: Value(amount),
          id: Value(balance.id));
      return await db.updateBalance(newBal);
    } catch (e, stackTrace) {
      AppLogger.instance
          .error("Failed to insert balance. ${e.toString()}", [stackTrace]);
      rethrow;
    }
  }

  @override
  Future<int> getClosingBalance(
      {required int account, required DateTime closingDate}) async {
    try {
      return await db.getClosingBalance(account, closingDate);
    } catch (e) {
      AppLogger.instance.error("Failed to get balance. ${e.toString()}");
      rethrow;
    }
  }

  @override
  Future<int> delete(int id) async {
    try {
      return await db.deleteBalance(id);
    } catch (e) {
      AppLogger.instance.error("Failed to delete balance. ${e.toString()}");
      rethrow;
    }
  }

  @override
  Future<int> getFundClosingBalance(DateTime closingDate, int profileID) async {
    try {
      return await db.getFundClosingBalance(closingDate, profileID);
    } catch (e, stackTrace) {
      AppLogger.instance.error(
          "Failed to get fund closing balance. ${e.toString()}", [stackTrace]);
      rethrow;
    }
  }
}

