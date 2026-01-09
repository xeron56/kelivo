import 'package:finance_tracker/app/extensions/drift_models.dart';
import 'package:finance_tracker/core/abstracts/account_types_repository.dart';
import 'package:finance_tracker/core/db/app_drift_database.dart';
import 'package:finance_tracker/core/models/domain/account_type.dart';
import 'package:finance_tracker/utils/app_logger.dart';

class AccountTypesDriftRepository implements AccountTypesRepository {
  AccountTypesDriftRepository(this.db);
  final AppDriftDatabase db;

  @override
  Future<List<AccountType>> getAll() async {
    try {
      return (await db.getAccTypes()).map((a) => a.toDomain()).toList();
    } catch (e) {
      AppLogger.instance
          .error("Failed to get AccountType list. ${e.toString()}");
      rethrow;
    }
  }

  @override
  Future<int> delete(int id) async {
    try {
      return 0;
    } catch (e) {
      AppLogger.instance.error("Failed to delete AccountType. ${e.toString()}");
      rethrow;
    }
  }

  @override
  Future<AccountType> getById(int id) async {
    try {
      return (await db.getAccTypeById(id)).toDomain();
    } catch (e) {
      AppLogger.instance.error("Failed to get AccountType. ${e.toString()}");
      rethrow;
    }
  }

  @override
  Future<AccountType> getAccTypeByType(int type) async {
    try {
      return (await db.getAccTypeByType(type)).toDomain();
    } catch (e) {
      AppLogger.instance.error(
          "Failed to get Accounts AccountType by primary type. ${e.toString()}");
      rethrow;
    }
  }

  @override
  Future<List<AccountType>> getAccTypesByCategory(List<int> accTypeIDs) async {
    try {
      return (await db.getAccTypesByCategory(accTypeIDs))
          .map((a) => a.toDomain())
          .toList();
    } catch (e) {
      AppLogger.instance.error(
          "Failed to get Accounts AccountType by primary type. ${e.toString()}");
      rethrow;
    }
  }
}

