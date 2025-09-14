import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart' show PlatformDispatcher, kDebugMode;
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:stopwatch/app/app_bloc_observer.dart' show AppBlocObserver;
import 'package:utils/utils.dart';

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  hierarchicalLoggingEnabled = true;

  // Register all services
  _setupDependencies();
  // await GetIt.instance.allReady();

  final logger = GetIt.instance<CustomLogger>();

  // Setup global error handlers

  _registerErrorHandlers(logger);
  // Setup Bloc observer for logging bloc events and errors
  Bloc.observer = AppBlocObserver(logger);

  // Run the app
  runApp(await builder());
}

/// Register dependencies with GetIt
void _setupDependencies() {
  GetIt.instance.registerSingleton<CustomLogger>(CustomLogger());
}

/// Registers global error handlers for Flutter, platform,
/// and widget build errors.
void _registerErrorHandlers(CustomLogger errorLogger) {
  // Handle Flutter framework errors
  FlutterError.onError = (FlutterErrorDetails details) {
    errorLogger.log(
      Level.SEVERE,
      details.exceptionAsString(),
      error: details.exception,
      stackTrace: details.stack,
    );
  };

  // Handle errors from the underlying platform/OS
  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    errorLogger.log(
      Level.SEVERE,
      error.toString(),
      error: error,
      stackTrace: stack,
    );
    return true;
  };

  // Show fallback error UI when a widget fails to build
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Center(
      child: Text(
        kDebugMode
            ? details.exceptionAsString()
            : 'An unexpected error occurred.'.hardcoded,
      ),
    );
  };
}
