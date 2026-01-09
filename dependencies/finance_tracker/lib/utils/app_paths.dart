import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class AppPaths {
  static String _imagesPath = "";
  static const uuid = Uuid();

  static Future<void> init() async {
    if (_imagesPath.isNotEmpty) return; // already initialized

    final Directory appDir = await getApplicationSupportDirectory();
    final String securePath = p.join(appDir.path, "images");
    await Directory(securePath).create(recursive: true);

    _imagesPath = securePath;
  }

  static String get imagesDir {
    if (_imagesPath.isEmpty) {
      throw Exception("AppPaths not initialized. Call AppPaths.init() first.");
    }
    return _imagesPath;
  }

  static String uniqueFileName(String originalName) {
    final String extension = p.extension(originalName); // keeps ".jpg"
    return "${uuid.v4()}$extension";
  }
}
