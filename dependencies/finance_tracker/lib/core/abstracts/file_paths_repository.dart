import 'package:finance_tracker/core/enums/db_table_type.dart';

abstract class FilePathsRepository {
  Future<List<String>> getAll();
  Future<int> insertFilePath({
    required String path,
    required int parentTableID,
    required DBTableType tableType,
  });
  Future<bool> updateFilePath({
    required int id,
    required String path,
    required int parentTableID,
    required DBTableType tableType,
  });
  Future<int> delete(int id);
  Future<int> deleteFilePathByPath(String path);
  Future<int> deleteFilePathByParentID(int id);
  Future<String> getById(int id);
}

