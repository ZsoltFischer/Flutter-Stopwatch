import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:utils/src/logging/logging_sink.dart';

/// A sink for logging to the console
///
/// It uses `dart:developer` log function to log messages
/// in a standard format. Console logging is disabled in release mode.
class ConsoleLoggingSink implements LoggingSink {
  /// Creates a new [ConsoleLoggingSink] instance
  const ConsoleLoggingSink();

  @override
  Level get minLevel => Level.SEVERE;

  @override
  FutureOr<void> handleLogEntry(
    Level level,
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    // Skip console logging in release mode
    if (kReleaseMode) return null;

    final time = DateTime.now();
    log(
      '[$level] - $time - $message',
      level: level.value,
      name: 'Console',
      time: time,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
