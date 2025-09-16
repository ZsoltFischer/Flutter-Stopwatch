import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';
import 'package:stopwatch/app/injector.dart';
import 'package:utils/utils.dart';

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  hierarchicalLoggingEnabled = true;

  // Register all services
  await configureDependencies();

  final logger = getIt<CustomLogger>();

  // Setup global error handlers
  ErrorHandler.register(logger);
  // Setup Bloc observer for logging bloc events and errors
  Bloc.observer = AppBlocObserver(logger);

  // Run the app
  runApp(await builder());
}
