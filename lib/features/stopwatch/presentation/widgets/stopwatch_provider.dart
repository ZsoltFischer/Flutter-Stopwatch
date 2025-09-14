import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:stopwatch/features/stopwatch/data/repositories/stopwatch_repository_impl.dart';
import 'package:stopwatch/features/stopwatch/domain/services/stopwatch_service.dart';
import 'package:stopwatch/features/stopwatch/domain/usecases/usecases.dart';
import 'package:stopwatch/features/stopwatch/presentation/bloc/stopwatch_bloc.dart';

class StopwatchProvider extends StatelessWidget {
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
