import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:stopwatch/exceptions/exceptions.dart';
import 'package:stopwatch/features/stopwatch/presentation/bloc/stopwatch_bloc.dart';
import 'package:stopwatch/features/stopwatch/presentation/widgets/stopwatch_provider.dart';
import 'package:utils/utils.dart' show CustomLogger;

class StopwatchPage extends StatelessWidget {
  const StopwatchPage({super.key});

  static Page<void> page() => const CupertinoPage(
    child: StopwatchProvider(child: StopwatchPage()),
  );

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Column(
        children: [
          Center(child: Text('Stopwatch Page')),
          IconButton(
            icon: Icon(CupertinoIcons.waveform_path_badge_minus),
            onPressed: () {
              throw Exception('Simulated exception on button press');
            },
          ),
          IconButton(
            icon: Icon(CupertinoIcons.keyboard),
            onPressed: () {
              throw LocalStorageReadException();
            },
          ),
          IconButton(
            icon: Icon(CupertinoIcons.exclamationmark_circle),
            onPressed: () {
              /// Create a simulated Error
              throw TypeError();
            },
          ),

          IconButton(
            icon: Icon(CupertinoIcons.add),
            onPressed: () {
              /// Create a simulated Error
              throw FlutterError('Simulated FlutterError');
            },
          ),
          IconButton(
            icon: Icon(CupertinoIcons.hammer),
            onPressed: () {
              GetIt.instance<CustomLogger>().severe(
                'Simulated severe log message with',
                error: LocalStorageWriteException(),
                stackTrace: StackTrace.current,
              );
            },
          ),
          IconButton(
            icon: Icon(CupertinoIcons.f_cursive),
            onPressed: () {
              GetIt.instance<CustomLogger>().logException(
                LocalStorageReadException(),
                StackTrace.current,
              );
            },
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CupertinoButton.filled(
                child: const Text('Start'),
                onPressed: () {
                  context.read<StopwatchBloc>().start();
                },
              ),
              const SizedBox(width: 16),
              CupertinoButton.filled(
                child: const Text('Pause'),
                onPressed: () {
                  context.read<StopwatchBloc>().pause();
                },
              ),
              const SizedBox(width: 16),
              CupertinoButton.filled(
                child: const Text('Stop'),
                onPressed: () {
                  context.read<StopwatchBloc>().stop();
                },
              ),
            ],
          ),

          BlocBuilder<StopwatchBloc, StopwatchState>(
            builder: (context, state) {
              final duration = state.durationInMilliseconds ~/ 1000;
              final minutes = (duration ~/ 60).toString().padLeft(2, '0');
              final seconds = (duration % 60).toString().padLeft(2, '0');
              final milliseconds = (state.durationInMilliseconds % 1000)
                  .toString()
                  .padLeft(3, '0');
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 32.0),
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(text: '$minutes:$seconds'),
                      TextSpan(
                        text: '.$milliseconds',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.normal,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
