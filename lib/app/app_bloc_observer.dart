import 'package:bloc/bloc.dart';
import 'package:utils/utils.dart' show CustomLogger;

/// Custom [BlocObserver] for logging bloc events and errors.
class AppBlocObserver extends BlocObserver {
  /// Creates a const instance of [AppBlocObserver].
  const AppBlocObserver(this._logger);

  /// Log errors into the correct sinks
  final CustomLogger _logger;

  @override
  // Strict types ignored to match the overridden method
  // ignore: strict_raw_type
  void onTransition(Bloc bloc, Transition transition) {
    _logger.fine(
      '${bloc.runtimeType}: $transition',
    );
    super.onTransition(bloc, transition);
  }

  @override
  // Strict types ignored to match the overridden method
  // ignore: strict_raw_type
  void onChange(BlocBase bloc, Change change) {
    _logger.fine(
      '${bloc.runtimeType}: $change',
    );
    super.onChange(bloc, change);
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    _logger.severe(
      'Bloc error in ${bloc.runtimeType}',
      error: error,
      stackTrace: stackTrace,
    );
    super.onError(bloc, error, stackTrace);
  }
}
