import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:utils/src/exceptions/crash_reporter.dart';
import 'package:utils/src/logging/logging_sink.dart';

/// A sink for reporting crashes and errors
///
/// It uses a [CrashReporter] to report errors.
/// Reporting is disabled in debug mode.
class CrashReportingSink implements LoggingSink {
  /// Creates a new [CrashReportingSink] with the given [crashReporter]
  const CrashReportingSink([CrashReporter? crashReporter])
    : _crashReporter = crashReporter;

  final CrashReporter? _crashReporter;

  @override
  Level get minLevel => Level.SEVERE;

  @override
  FutureOr<void> handleLogEntry(
    Level level,
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    // Only report errors and above
    if (kDebugMode) return null;

    final reportedErrorMessage = '[$level] - ${DateTime.now()} - $message';
    _crashReporter?.report(reportedErrorMessage, error, stackTrace);
  }
}
