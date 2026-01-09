import 'package:drift/drift.dart';
import 'package:finance_tracker/app/extensions/drift_models.dart';
import 'package:finance_tracker/core/abstracts/receivables_repository.dart';
import 'package:finance_tracker/core/db/app_drift_database.dart';
import 'package:finance_tracker/core/models/domain/receivable.dart';
import 'package:finance_tracker/utils/app_logger.dart';

class ReceivablesDriftRepository implements ReceivablesRepository {
  ReceivablesDriftRepository(this.db);
  final AppDriftDatabase db;

  @override
  Future<int> insertReceivable({
    required int account,
    DateTime? paidDate,
    int? paidAmount,
  }) async {
    try {
      final receivable = DriftReceivablesCompanion(
        accountId: Value(account),
        paidDate: Value(paidDate),
        totalAmount: Value(paidAmount),
      );
      return await db.insertReceivable(receivable);
    } catch (e) {
      AppLogger.instance.error("Failed to insert receivable. ${e.toString()}");
      rethrow;
    }
  }

  @override
  Future<bool> updateReceivable({
    required int account,
    required int id,
    DateTime? paidDate,
    int? paidAmount,
  }) async {
    try {
      final receivable = DriftReceivablesCompanion(
        accountId: Value(account),
        id: Value(id),
        paidDate: Value(paidDate),
        totalAmount: Value(paidAmount),
      );
      return await db.updateReceivable(receivable);
    } catch (e) {
      AppLogger.instance.error("Failed to update receivable. ${e.toString()}");
      rethrow;
    }
  }

  @override
  Future<int> delete(int id) async {
    try {
      return await db.deleteReceivable(id);
    } catch (e) {
      AppLogger.instance.error("Failed to delete receivable. ${e.toString()}");
      rethrow;
    }
  }

  @override
  Future<Receivable> getById(int id) async {
    try {
      final account = (await db.getAccountbyId(id)).toDomain();
      return (await db.getReceivableById(id)).toDomain(account);
    } catch (e) {
      AppLogger.instance.error("Failed to get receivable. ${e.toString()}");
      rethrow;
    }
  }

  @override
  Future<Receivable> getByAccount(int id) async {
    try {
      final account = (await db.getAccountbyId(id)).toDomain();
      return (await db.getReceivableByAccount(id)).toDomain(account);
    } catch (e) {
      AppLogger.instance.error("Failed to get Bank. ${e.toString()}");
      rethrow;
    }
  }
}

