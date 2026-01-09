import 'package:drift/drift.dart';
import 'package:finance_tracker/app/extensions/drift_models.dart';
import 'package:finance_tracker/core/abstracts/banks_repository.dart';
import 'package:finance_tracker/core/db/app_drift_database.dart';
import 'package:finance_tracker/core/models/domain/bank.dart';
import 'package:finance_tracker/utils/app_logger.dart';

class BanksDriftRepository implements BanksRepository {
  BanksDriftRepository(this.db);
  final AppDriftDatabase db;

  @override
  Future<int> insertBank(
      {required int account,
      required String? branch,
      required String? branchCode,
      required String? holderName,
      required String? accountNo,
      required String? institution}) async {
    try {
      final bank = DriftBanksCompanion(
        account: Value(account),
        accountNo: Value(accountNo),
        branch: Value(branch),
        branchCode: Value(branchCode),
        holderName: Value(holderName),
        institution: Value(institution),
      );
      return await db.insertBank(bank);
    } catch (e) {
      AppLogger.instance.error("Failed to insert bank. ${e.toString()}");
      rethrow;
    }
  }

  @override
  Future<bool> updateBank(
      {required int id,
      required int account,
      required String? branch,
      required String? branchCode,
      required String? accountNo,
      required String? holderName,
      required String? institution}) async {
    try {
      final bank = DriftBanksCompanion(
        id: Value(id),
        account: Value(account),
        accountNo: Value(accountNo),
        branch: Value(branch),
        branchCode: Value(branchCode),
        holderName: Value(holderName),
        institution: Value(
          institution,
        ),
      );
      return await db.updateBank(bank);
    } catch (e) {
      AppLogger.instance.error("Failed to insert bank. ${e.toString()}");
      rethrow;
    }
  }

  @override
  Future<int> delete(int id) async {
    try {
      return await db.deleteBank(id);
    } catch (e) {
      AppLogger.instance.error("Failed to delete bank. ${e.toString()}");
      rethrow;
    }
  }

  @override
  Future<Bank> getById(int id) async {
    try {
      final account = (await db.getAccountbyId(id)).toDomain();
      return (await db.getBankById(id)).toDomain(account);
    } catch (e) {
      AppLogger.instance.error("Failed to get bank. ${e.toString()}");
      rethrow;
    }
  }

  @override
  Future<Bank> getByAccount(int id) async {
    try {
      final account = (await db.getAccountbyId(id)).toDomain();
      return (await db.getBankByAccount(id)).toDomain(account);
    } catch (e) {
      AppLogger.instance.error("Failed to get Bank. ${e.toString()}");
      rethrow;
    }
  }
}

