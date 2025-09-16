/// A simple interface for crash reporting services.
///
/// Intended to be implemented by app specific classes that integrate with
/// crash reporting services like Sentry, Firebase Crashlytics,
/// or custom solutions.
// ignore: one_member_abstracts
abstract interface class CrashReporter {
  /// Report an [error] along with a [stackTrace] and a
  /// [message] to the crash reporting service
  void report(String message, Object? error, StackTrace? stackTrace);
}
