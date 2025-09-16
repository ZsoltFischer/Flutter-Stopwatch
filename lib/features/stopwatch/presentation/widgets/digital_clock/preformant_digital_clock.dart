import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stopwatch/features/stopwatch/presentation/bloc/stopwatch_bloc.dart';
import 'package:utils/utils.dart';

class PerformantDigitalClock extends StatefulWidget {
  const PerformantDigitalClock({super.key});

  @override
  State<PerformantDigitalClock> createState() => _PerformantDigitalClockState();
}

class _PerformantDigitalClockState extends State<PerformantDigitalClock> {
  late final Stream<StopwatchState> _filteredStream;

  @override
  void initState() {
    super.initState();
    final bloc = context.read<StopwatchBloc>();

    // Filter the bloc's stream using RxDart's throttleTime operator
    _filteredStream = bloc.stream
        .throttleTime(const Duration(milliseconds: 100))
        .startWith(bloc.state);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<StopwatchState>(
      stream: _filteredStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }

        final elapsedTime = snapshot.data!.elapsedTimeInMs;

        return Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              Duration(
                milliseconds: elapsedTime,
              ).toDigitalClock(),
              textAlign: TextAlign.center,
              maxLines: 1,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'RobotoMono',
              ),
            ),
          ),
        );
      },
    );
  }
}
