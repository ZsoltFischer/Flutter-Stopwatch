import 'dart:async';
import 'package:logging/logging.dart';

/// A sink for log entries.
abstract class LoggingSink {
  /// Minimum level this sink cares about
  Level get minLevel;

  /// Handle a log entry with given [level], [message],
  /// optional [error] and [stackTrace]
  FutureOr<void> handleLogEntry(
    Level level,
    String message, {
    Object? error,
    StackTrace? stackTrace,
  });
}
