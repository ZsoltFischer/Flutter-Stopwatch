import 'package:flutter/scheduler.dart' show Ticker;
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stopwatch/features/stopwatch/domain/bloc/stopwatch_bloc.dart';

typedef Widget ClockChildBuilder(int elapsedMs);

class AnimatedClock extends StatefulWidget {
  const AnimatedClock({required this.child, super.key});

  final ClockChildBuilder child;

  @override
  State<AnimatedClock> createState() => _AnimatedClockState();
}

class _AnimatedClockState extends State<AnimatedClock>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  int _elapsed = 0;

  void _onTick(Duration _) {
    if (!mounted) return;

    setState(() {
      //! Why do I even use BLoC at this point...?
      _elapsed = context.read<StopwatchBloc>().currentMs;
    });
  }

  @override
  void initState() {
    super.initState();
    _ticker = Ticker(_onTick)..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child(_elapsed);
  }
}
