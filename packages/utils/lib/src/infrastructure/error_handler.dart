import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';
import 'package:utils/utils.dart';

/// Defines a widget builder for error widgets using [FlutterErrorDetails].
///
/// Application specific error widget builders can be provided
/// to customize the appearance of error screens.
typedef ErrorWidgetBuilder = Widget Function(FlutterErrorDetails);

/// A centralized error handler to register global error handlers
/// for Flutter framework errors, platform errors, and widget build errors.
class ErrorHandler {
  /// Registers global error handlers using the provided [logger].
  static void register(
    CustomLogger logger, {
    ErrorWidgetBuilder? errorWidgetBuilder,
  }) {
    FlutterError.onError = (FlutterErrorDetails details) {
      logger.log(
        Level.SEVERE,
        details.exceptionAsString(),
        error: details.exception,
        stackTrace: details.stack,
      );
    };

    PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
      logger.log(
        Level.SEVERE,
        error.toString(),
        error: error,
        stackTrace: stack,
      );
      return true;
    };

    ErrorWidget.builder = (FlutterErrorDetails details) {
      if (errorWidgetBuilder != null) {
        return errorWidgetBuilder(details);
      }
      return Center(
        child: Text(
          kDebugMode
              ? details.exceptionAsString()
              : 'An unexpected error occurred.'.hardcoded,
        ),
      );
    };
  }
}
