import 'package:logger/logger.dart';

class AppLogger {
  // Private constructor to prevent external instantiation
  AppLogger._privateConstructor();

  // The single instance of AppLogger, created lazily
  static final AppLogger _instance = AppLogger._privateConstructor();

  // Public getter to access the singleton instance
  static AppLogger get instance => _instance;

  // The logger instance
  final Logger _logger = Logger(
    printer: PrettyPrinter(),
  );

  // Log methods
  void debug(String message) {
    _logger.d(message);
  }

  void info(String message) {
    _logger.i(message);
  }

  void warning(String message) {
    _logger.w(message);
  }

  void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }
}
