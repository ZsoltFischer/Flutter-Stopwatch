import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stopwatch/features/stopwatch/domain/bloc/stopwatch_bloc.dart';
import 'package:utils/utils.dart';

class DigitalClock extends StatelessWidget {
  const DigitalClock({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Center(
        child: StreamBuilder<int>(
          stream: context.read<StopwatchBloc>().msStream,
          builder: (context, snapshot) {
            return FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                key: const ValueKey('DigitalClock'),
                Duration(milliseconds: snapshot.data ?? 0).toDigitalClock(),
                textAlign: TextAlign.center,
                maxLines: 1,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'RobotoMono',
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
