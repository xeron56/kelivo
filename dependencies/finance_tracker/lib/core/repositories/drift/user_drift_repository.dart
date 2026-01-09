import 'package:drift/drift.dart';
import 'package:finance_tracker/app/extensions/drift_models.dart';
import 'package:finance_tracker/core/abstracts/user_repository.dart';
import 'package:finance_tracker/core/db/app_drift_database.dart';
import 'package:finance_tracker/core/models/domain/user.dart';
import 'package:finance_tracker/utils/app_logger.dart';

class UserDriftRepository implements UserRepository {
  UserDriftRepository(this.db);
  final AppDriftDatabase db;

  @override
  Future<User> getById(int id) async {
    try {
      final account = (await db.getAccountbyId(id)).toDomain();
      return (await db.getUserById(id)).toDomain(account);
    } catch (e) {
      AppLogger.instance.error("Failed to get user. ${e.toString()}");
      rethrow;
    }
  }

  @override
  Future<int> insertUser(
      {required String name,
      required String deviceID,
      required String filePath}) async {
    try {
      final driftUser = DriftUsersCompanion(
        name: Value(name),
        deviceID: Value(deviceID),
        photoPath: Value(filePath),
      );
      return db.insertUser(driftUser);
    } catch (e) {
      AppLogger.instance.error("Failed to insert user. ${e.toString()}");
      rethrow;
    }
  }

  @override
  Future<bool> updateUser(
      {required int dbID,
      required String name,
      required String deviceID,
      required String filePath}) {
    try {
      final driftUser = DriftUsersCompanion(
        id: Value(dbID),
        name: Value(name),
        deviceID: Value(deviceID),
        photoPath: Value(filePath),
      );
      return db.updateUser(driftUser);
    } catch (e) {
      AppLogger.instance.error("Failed to update user. ${e.toString()}");
      rethrow;
    }
  }
}

