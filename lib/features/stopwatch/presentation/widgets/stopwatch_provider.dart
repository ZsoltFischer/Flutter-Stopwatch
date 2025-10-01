import 'package:clock/clock.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:stopwatch/features/stopwatch/data/repositories/stopwatch_repository_impl.dart';
import 'package:stopwatch/features/stopwatch/domain/services/stopwatch_service.dart';
import 'package:stopwatch/features/stopwatch/domain/usecases/usecases.dart';
import 'package:stopwatch/features/stopwatch/domain/bloc/stopwatch_bloc.dart';

/// A provider widget that sets up the necessary
/// dependencies for the stopwatch feature,
/// including the [StopwatchService], [StopwatchRepositoryImpl],
/// and [StopwatchBloc]. This widget should wrap
/// the part of the widget tree that requires access to these dependencies.
class StopwatchProvider extends StatelessWidget {
  /// Creates a [StopwatchProvider] widget.
  const StopwatchProvider({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          lazy: false,
          create: (context) =>
              StopwatchService(clock: Clock(), tickFrequencyHz: 30),
          dispose: (context, service) => service.dispose(),
        ),

        RepositoryProvider<StopwatchRepositoryImpl>(
          create: (context) => StopwatchRepositoryImpl(
            stopwatchService: context.read<StopwatchService>(),
          ),
        ),

        BlocProvider<StopwatchBloc>(
          create: (context) {
            final stopwatchRepository = context.read<StopwatchRepositoryImpl>();

            return StopwatchBloc(
              stopwatchService: context.read<StopwatchService>(),
              startStopwatchUsecase: StartStopwatchUsecase(
                stopwatchRepository: stopwatchRepository,
              ),
              pauseStopwatchUsecase: PauseStopwatchUsecase(
                stopwatchRepository: stopwatchRepository,
              ),
              stopStopwatchUsecase: StopStopwatchUsecase(
                stopwatchRepository: stopwatchRepository,
              ),
              recordLapUsecase: RecordLapUsecase(
                stopwatchRepository: stopwatchRepository,
              ),
            );
          },
          lazy: false,
        ),
      ],
      child: child,
    );
  }
}
