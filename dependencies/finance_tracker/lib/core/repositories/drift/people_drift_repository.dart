import 'package:drift/drift.dart';
import 'package:finance_tracker/app/extensions/drift_models.dart';
import 'package:finance_tracker/core/abstracts/people_repository.dart';
import 'package:finance_tracker/core/db/app_drift_database.dart';
import 'package:finance_tracker/core/models/domain/people.dart';
import 'package:finance_tracker/utils/app_logger.dart';

class PeopleDriftRepository implements PeopleRepository {
  PeopleDriftRepository(this.db);
  final AppDriftDatabase db;

  @override
  Future<int> insertPeople({
    required int account,
    String? address,
    String? email,
    String? tin,
    String? phone,
    String? zip,
  }) async {
    try {
      final people = DriftPeopleCompanion.insert(
        accountId: account,
        address: Value(address),
        email: Value(email),
        phone: Value(phone),
        tin: Value(tin),
        zip: Value(zip),
      );
      return await db.insertPeople(people);
    } catch (e) {
      AppLogger.instance.error("Failed to insert people. ${e.toString()}");
      rethrow;
    }
  }

  @override
  Future<bool> updatePeople({
    required int account,
    required int id,
    String? address,
    String? email,
    String? tin,
    String? phone,
    String? zip,
  }) async {
    try {
      final people = DriftPeopleCompanion(
        accountId: Value(account),
        id: Value(id),
        address: Value(address),
        email: Value(email),
        phone: Value(phone),
        tin: Value(tin),
        zip: Value(zip),
      );
      return await db.updatePeople(people);
    } catch (e) {
      AppLogger.instance.error("Failed to update people. ${e.toString()}");
      rethrow;
    }
  }

  @override
  Future<int> delete(int id) async {
    try {
      return await db.deletePeople(id);
    } catch (e) {
      AppLogger.instance.error("Failed to delete people. ${e.toString()}");
      rethrow;
    }
  }

  @override
  Future<People> getById(int id) async {
    try {
      final account = (await db.getAccountbyId(id)).toDomain();
      return (await db.getPeopleById(id)).toDomain(account);
    } catch (e) {
      AppLogger.instance.error("Failed to get people. ${e.toString()}");
      rethrow;
    }
  }

  @override
  Future<People> getByAccount(int id) async {
    try {
      final account = (await db.getAccountbyId(id)).toDomain();
      return (await db.getPeopleByAccount(id)).toDomain(account);
    } catch (e) {
      AppLogger.instance.error("Failed to get Bank. ${e.toString()}");
      rethrow;
    }
  }
}

