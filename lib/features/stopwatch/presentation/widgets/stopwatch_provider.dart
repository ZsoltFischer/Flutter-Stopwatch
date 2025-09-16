import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:stopwatch/features/stopwatch/data/repositories/stopwatch_repository_impl.dart';
import 'package:stopwatch/features/stopwatch/domain/services/stopwatch_service.dart';
import 'package:stopwatch/features/stopwatch/domain/usecases/usecases.dart';
import 'package:stopwatch/features/stopwatch/presentation/bloc/stopwatch_bloc.dart';

/// A provider widget that sets up the necessary
/// dependencies for the stopwatch feature,
/// including the [StopwatchService], [StopwatchRepositoryImpl],
/// and [StopwatchBloc]. This widget should wrap
/// the part of the widget tree that requires access to these dependencies.
class StopwatchProvider extends StatelessWidget {
  /// Creates a [StopwatchProvider] widget.
  const StopwatchProvider({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          create: (context) => StopwatchService(),
        ),

        RepositoryProvider<StopwatchRepositoryImpl>(
          create: (context) => StopwatchRepositoryImpl(
            stopwatchService: context.read<StopwatchService>(),
          ),
        ),

        BlocProvider<StopwatchBloc>(
          create: (context) => StopwatchBloc(
            stopwatchService: context.read<StopwatchService>(),
            startStopwatchUsecase: StartStopwatchUsecase(
              stopwatchRepository: context.read<StopwatchRepositoryImpl>(),
            ),
            pauseStopwatchUsecase: PauseStopwatchUsecase(
              stopwatchRepository: context.read<StopwatchRepositoryImpl>(),
            ),
            stopStopwatchUsecase: StopStopwatchUsecase(
              stopwatchRepository: context.read<StopwatchRepositoryImpl>(),
            ),
            recordLapUsecase: RecordLapUsecase(
              stopwatchRepository: context.read<StopwatchRepositoryImpl>(),
            ),
          ),
          lazy: false,
        ),
      ],
      child: child,
    );
  }
}
