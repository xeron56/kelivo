import 'package:finance_tracker/core/models/domain/account.dart';
import 'package:finance_tracker/core/models/domain/ledger.dart';

abstract class AccountsRepository {
  Future<int> insertAccount({
    required String name,
    required int openBal,
    required DateTime openDate,
    required int accType,
    required int profile,
  });

  Future<bool> updateAccount({
    required int id,
    required String name,
    required int openBal,
    required DateTime openDate,
    required int accType,
    required int profile,
  });

  Future<int> delete(int id);
  Future<Account> getById(int id);
  Future<List<Account>> getAccountsByProfile({required int profileId});
  Future<List<Ledger>> getLedgers({required int profileId});
  Future<List<Ledger>> getLedgersByAccType({
    required int profileId,
    required int accTypeID,
  });
  Future<List<Ledger>> getLedgersByCategory(
      {required int profileId, required List<int> accTypeIDs});

  Future<List<Account>> getAccountsByAccType(int profileId, int accType);

  Future<void> insertAccountsBulk(
      List<String> names, int accType, int profile, DateTime openDate);

  Future<List<Account>> getAccountsByCategory(
      {required int profileId, required List<int> accTypeIDs});
}

