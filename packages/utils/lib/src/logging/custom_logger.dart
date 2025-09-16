import 'package:logging/logging.dart';
import 'package:utils/src/logging/console_logging_sink.dart';
import 'package:utils/src/logging/crash_reporter_sink.dart';
import 'package:utils/src/logging/logging_sink.dart';

/// Logger with multiple sinks
///
/// It log to the console in a standard format and can report crashes
/// to a crash reporting service. App-specific crash reporting sinks can
/// be added as long as they implement [LoggingSink]
///
/// Crash reporting is disabled in debug mode, console logging is disabled
/// in release mode.
class CustomLogger {
  /// Creates a logger with optional sinks
  CustomLogger({
    String name = 'App',
    List<LoggingSink>? sinks,
  }) : _logger = Logger(name),
       _sinks =
           sinks ?? [const ConsoleLoggingSink(), const CrashReportingSink()] {
    _logger.level = Level.ALL;
    _logger.onRecord.listen(_handleRecord);
  }

  /// The underlying logger
  final Logger _logger;

  /// The list of sinks
  final List<LoggingSink> _sinks;

  /// Forward log records to sinks
  void _handleRecord(LogRecord record) {
    for (final sink in _sinks) {
      if (record.level < sink.minLevel) continue;
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
