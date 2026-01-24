import 'package:logger/logger.dart';

class LogService {
  static final Logger _logger = Logger(
    filter: DevelopmentFilter(),
    printer: PrettyPrinter(),
  );

  static void d(String message) {
    _logger.d(message);
    // also print to ensure visibility in all run modes
    // (useful when logger filter suppresses messages)
    // ignore: avoid_print
    print("DEBUG: $message");
  }

  static void i(String message) {
    _logger.i(message);
    // ignore: avoid_print
    print("INFO: $message");
  }

  static void w(String message) {
    _logger.w(message);
    // ignore: avoid_print
    print("WARN: $message");
  }

  static void e(String message) {
    _logger.e(message);
    // ignore: avoid_print
    print("ERROR: $message");
  }
}