import 'dart:async';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:utils/src/exceptions/crash_reporter.dart';

/// --- Abstract logging sink ---
// ignore: one_member_abstracts
abstract class LoggingSink {
  @protected
  /// Handle a log entry with given [level], [message],
  /// optional [error] and [stackTrace]
  FutureOr<void> handleLogEntry(
    Level level,
    String message, {
    Object? error,
    StackTrace? stackTrace,
  });
}

/// --- Console sink ---
class ConsoleLoggingSink implements LoggingSink {
  /// Creates a new [ConsoleLoggingSink] instance
  const ConsoleLoggingSink();

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

/// --- Crash reporting sink ---
class CrashReportingSink implements LoggingSink {
  /// Creates a new [CrashReportingSink] with the given [crashReporter]
  const CrashReportingSink([CrashReporter? crashReporter])
    : _crashReporter = crashReporter;

  final CrashReporter? _crashReporter;

  @override
  FutureOr<void> handleLogEntry(
    Level level,
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    // Only report errors and above
    if (kDebugMode || level < Level.SEVERE) return null;

    final reportedErrorMessage = '[$level] - ${DateTime.now()} - $message';
    _crashReporter?.report(reportedErrorMessage, error, stackTrace);
  }
}

/// --- Central logger ---
class CustomLogger {
  /// Creates a logger with optional sinks
  CustomLogger({String name = 'App', List<LoggingSink>? sinks})
    : _logger = Logger(name),
      _sinks =
          sinks ?? [const ConsoleLoggingSink(), const CrashReportingSink()] {
    _logger.level = Level.ALL;
    _logger.onRecord.listen(_handleRecord);
  }

  final Logger _logger;
  final List<LoggingSink> _sinks;

  /// Forward log records to sinks
  void _handleRecord(LogRecord record) {
    for (final sink in _sinks) {
      sink.handleLogEntry(
        record.level,
        record.message,
        error: record.error,
        stackTrace: record.stackTrace,
      );
    }
  }

  /// Log any message with specified level
  void log(
    Level level,
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    _logger.log(level, message, error, stackTrace);
  }

  /// A very low priority tracing message.
  void finest(String message, {Object? error, StackTrace? stackTrace}) {
    log(Level.FINEST, message, error: error, stackTrace: stackTrace);
  }

  /// A fairly detailed tracing message.
  void fine(String message, {Object? error, StackTrace? stackTrace}) {
    log(Level.FINE, message, error: error, stackTrace: stackTrace);
  }

  /// A general informational message.
  void info(String message, {Object? error, StackTrace? stackTrace}) {
    log(Level.INFO, message, error: error, stackTrace: stackTrace);
  }

  /// A warning message.
  void warning(String message, {Object? error, StackTrace? stackTrace}) {
    log(Level.WARNING, message, error: error, stackTrace: stackTrace);
  }

  /// A serious failure.
  void severe(String message, {Object? error, StackTrace? stackTrace}) {
    log(Level.SEVERE, message, error: error, stackTrace: stackTrace);
  }

  /// A very severe error event that will presumably lead
  /// the application to abort.
  void shout(String message, {Object? error, StackTrace? stackTrace}) {
    log(Level.SHOUT, message, error: error, stackTrace: stackTrace);
  }

  /// Convenience for exceptions
  void logException(Exception exception, [StackTrace? stackTrace]) {
    severe('Exception: $exception', error: exception, stackTrace: stackTrace);
  }
}
