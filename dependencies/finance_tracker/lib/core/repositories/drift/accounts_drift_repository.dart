import 'package:drift/drift.dart';
import 'package:finance_tracker/app/extensions/drift_models.dart';
import 'package:finance_tracker/core/abstracts/accounts_repository.dart';
import 'package:finance_tracker/core/db/app_drift_database.dart';
import 'package:finance_tracker/core/models/domain/account.dart';
import 'package:finance_tracker/core/models/domain/ledger.dart';
import 'package:finance_tracker/utils/app_logger.dart';

class AccountsDriftRepository implements AccountsRepository {
  final AppDriftDatabase db;
  AccountsDriftRepository(this.db);

  @override
  Future<int> insertAccount(
      {required String name,
      required int openBal,
      required DateTime openDate,
      required int accType,
      required int profile}) async {
    try {
      final account = DriftAccountsCompanion(
        name: Value(name),
        accType: Value(accType),
        openBal: Value(openBal),
        openDate: Value(openDate),
        profile: Value(profile),
      );
      AppLogger.instance.info("Creating account $name.");
      return await db.insertAccount(account);
    } catch (e) {
      AppLogger.instance.error("Failed to update account. ${e.toString()}");
      rethrow;
    }
  }

  @override
  Future<bool> updateAccount(
      {required int id,
      required String name,
      required int openBal,
      required DateTime openDate,
      required int accType,
      required int profile}) async {
    try {
      final account = DriftAccountsCompanion(
        id: Value(id),
        name: Value(name),
        accType: Value(accType),
        openBal: Value(openBal),
        openDate: Value(openDate),
        profile: Value(profile),
        updateDate: Value(DateTime.now()),
      );
      AppLogger.instance.info("Updating account $name.");
      return await db.updateAccount(account);
    } catch (e) {
      AppLogger.instance.error("Failed to insert account. ${e.toString()}");
      rethrow;
    }
  }

  @override
  Future<int> delete(int id) async {
    try {
      return await db.deleteAccount(id);
    } catch (e) {
      AppLogger.instance.error("Failed to delete account. ${e.toString()}");
      rethrow;
    }
  }

  @override
  Future<Account> getById(int id) async {
    try {
      return (await db.getAccountbyId(id)).toDomain();
    } catch (e) {
      AppLogger.instance.error("Failed to get account. ${e.toString()}");
      rethrow;
    }
  }

  @override
  Future<List<Account>> getAccountsByProfile({required int profileId}) async {
    try {
      return (await db.getAccountsByProfile(profileId))
          .map((a) => a.toDomain())
          .toList();
    } catch (e) {
      AppLogger.instance.error("Failed to get accounts list. ${e.toString()}");
      rethrow;
    }
  }

  @override
  Future<List<Ledger>> getLedgers({required int profileId}) async {
    try {
      return (await db.getLedgers(profileId: profileId))
          .map(
            (a) => Ledger(
                account: a.item1.toDomain(),
                accountType: a.item2.toDomain(),
                balance: a.item3.amount),
          )
          .toList();
    } catch (e) {
      AppLogger.instance.error("Failed to get accounts list. ${e.toString()}");
      rethrow;
    }
  }

  @override
  Future<List<Account>> getAccountsByAccType(int profileId, int accType) async {
    try {
      return (await db.getAccountsByAccType(profileId, accType))
          .map((a) => a.toDomain())
          .toList();
    } catch (e) {
      AppLogger.instance.error("Failed to get accounts list. ${e.toString()}");
      rethrow;
    }
  }

  @override
  Future<void> insertAccountsBulk(
      List<String> names, int accType, int profile, DateTime openDate) async {
    try {
      List<DriftAccountsCompanion> accounts = names
          .map((a) => DriftAccountsCompanion.insert(
              name: a,
              accType: accType,
              profile: profile,
              openDate: Value(openDate)))
          .toList();
      return await db.insertAccounts(accounts);
    } catch (e) {
      AppLogger.instance
          .error("Failed to insert bulk accounts. ${e.toString()}");
      rethrow;
    }
  }

  @override
  Future<List<Ledger>> getLedgersByAccType(
      {required int profileId, required int accTypeID}) async {
    try {
      return (await db.getLedgersByAccType(
              profileId: profileId, accTypeID: accTypeID))
          .map(
            (a) => Ledger(
                account: a.item1.toDomain(),
                accountType: a.item2.toDomain(),
                balance: a.item3.amount),
          )
          .toList();
    } catch (e) {
      AppLogger.instance.error("Failed to get accounts list. ${e.toString()}");
      rethrow;
    }
  }

  @override
  Future<List<Ledger>> getLedgersByCategory(
      {required int profileId, required List<int> accTypeIDs}) async {
    try {
      return (await db.getLedgersByCategory(
              profileId: profileId, accTypeIDs: accTypeIDs))
          .map(
            (a) => Ledger(
                account: a.item1.toDomain(),
                accountType: a.item2.toDomain(),
                balance: a.item3.amount),
          )
          .toList();
    } catch (e) {
      AppLogger.instance.error("Failed to get accounts list. ${e.toString()}");
      rethrow;
    }
  }

  @override
  Future<List<Account>> getAccountsByCategory(
      {required int profileId, required List<int> accTypeIDs}) async {
    try {
      return (await db.getAccountsByCategory(
              profileID: profileId, accTypeIDs: accTypeIDs))
          .map((a) => a.toDomain())
          .toList();
    } catch (e) {
      AppLogger.instance.error("Failed to get accounts list. ${e.toString()}");
      rethrow;
    }
  }
}

