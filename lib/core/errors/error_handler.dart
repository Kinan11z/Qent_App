import 'package:flutter/foundation.dart';

class ErrorHandler {
  /// Capture any exception globally
  static Future<void> capture(
    dynamic error, {
    StackTrace? stackTrace,
    String? source, // e.g., "network", "repository", "use_case", "model"
    Map<String, dynamic>? extra,
    String? message,
  }) async {
    if (kDebugMode) {
      print('❌ Error [$source]: $error');
      if (stackTrace != null) print('StackTrace: $stackTrace');
    }
  }
}
