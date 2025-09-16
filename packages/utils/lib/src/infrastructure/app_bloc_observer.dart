import 'package:bloc/bloc.dart';
import 'package:utils/src/logging/custom_logger.dart';

/// Custom [BlocObserver] for logging bloc events and errors.
class AppBlocObserver extends BlocObserver {
  /// Creates a const instance of [AppBlocObserver].
  const AppBlocObserver(this._logger);

  /// Log errors into the correct sinks
  final CustomLogger _logger;

  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    _logger.fine(
      '${bloc.runtimeType}: $transition',
    );
    super.onTransition(bloc, transition);
  }

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
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
