import 'package:drift/drift.dart';
import 'package:finance_tracker/core/abstracts/file_paths_repository.dart';
import 'package:finance_tracker/core/db/app_drift_database.dart';
import 'package:finance_tracker/core/enums/db_table_type.dart';
import 'package:finance_tracker/utils/app_logger.dart';

class FilePathsDriftRepository implements FilePathsRepository {
  FilePathsDriftRepository(this.db);
  final AppDriftDatabase db;

  @override
  Future<int> insertFilePath({
    required String path,
    required int parentTableID,
    required DBTableType tableType,
  }) async {
    try {
      final filePath = DriftFilePathsCompanion.insert(
        path: path,
        parentTable: parentTableID,
        tableType: tableType,
      );
      return await db.insertFilePath(filePath);
    } catch (e) {
      AppLogger.instance.error("Failed to insert file path. ${e.toString()}");
      rethrow;
    }
  }

  @override
  Future<bool> updateFilePath({
    required int id,
    required String path,
    required int parentTableID,
    required DBTableType tableType,
  }) async {
    try {
      final filePath = DriftFilePathsCompanion(
        id: Value(id),
        path: Value(path),
        parentTable: Value(parentTableID),
        tableType: Value(tableType),
      );
      return await db.updateFilePath(filePath);
    } catch (e) {
      AppLogger.instance.error("Failed to update file path. ${e.toString()}");
      rethrow;
    }
  }

  @override
  Future<int> delete(int id) async {
    try {
      return await db.deleteFilePath(id);
    } catch (e) {
      AppLogger.instance.error("Failed to delete file path. ${e.toString()}");
      rethrow;
    }
  }

  @override
  Future<String> getById(int id) async {
    try {
      return (await db.getFilePathById(id)).path;
    } catch (e) {
      AppLogger.instance.error("Failed to get file path. ${e.toString()}");
      rethrow;
    }
  }

  @override
  Future<int> deleteFilePathByPath(String path) async {
    try {
      return await db.deleteFilePathByPath(path);
    } catch (e) {
      AppLogger.instance.error("Failed to delete file path. ${e.toString()}");
      rethrow;
    }
  }

  @override
  Future<List<String>> getAll() async {
    try {
      return [];
    } catch (e) {
      AppLogger.instance.error("Failed to get file path. ${e.toString()}");
      rethrow;
    }
  }

  @override
  Future<int> deleteFilePathByParentID(int id) async {
    try {
      return await db.deleteFilePathByParentID(id);
    } catch (e) {
      AppLogger.instance.error("Failed to delete file path. ${e.toString()}");
      rethrow;
    }
  }
}

