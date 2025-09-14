import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:stopwatch/features/stopwatch/presentation/bloc/stopwatch_bloc.dart';

class FakeStopwatchBloc extends Fake implements StopwatchBloc {
  FakeStopwatchBloc(this._state);

  final _controller = StreamController<StopwatchState>.broadcast();

  StopwatchState _state;

  @override
  StopwatchState get state => _state;

  @override
  Stream<StopwatchState> get stream => _controller.stream;

  @override
  void emit(StopwatchState state) {
    _state = state;
    _controller.add(state);
  }

  @override
  void start() {}

  @override
  void pause() {}

  @override
  void stop() {}

  @override
  void recordLap() {}

  void dispose() => _controller.close();
}
