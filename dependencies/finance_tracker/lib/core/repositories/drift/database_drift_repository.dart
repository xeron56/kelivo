import 'dart:io';

import 'package:finance_tracker/core/abstracts/database_repository.dart';
import 'package:finance_tracker/core/db/app_drift_database.dart';
import 'package:finance_tracker/utils/app_logger.dart';

class DatabaseDriftRepository implements DatabaseRepository {
  final AppDriftDatabase db;

  DatabaseDriftRepository(this.db);
  @override
  Future<void> exportDatabase(File destination) async {
    try {
      await db.exportDatabase(destination);
    } catch (e) {
      AppLogger.instance
          .error("Failed to back up the database. ${e.toString()}");
      rethrow;
    }
  }

  @override
  Future<void> restoreDatabase(File backupFile) {
    // TODO: implement restoreDatabase
    throw UnimplementedError();
  }
}

