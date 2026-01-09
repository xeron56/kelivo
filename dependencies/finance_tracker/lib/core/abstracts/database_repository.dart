import 'dart:io';

abstract class DatabaseRepository {
  Future<void> exportDatabase(File destination);
  Future<void> restoreDatabase(File backupFile);
}
