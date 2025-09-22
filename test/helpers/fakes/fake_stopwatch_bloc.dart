// ignore_for_file: no-empty-block

import 'package:flutter_test/flutter_test.dart';
import 'package:stopwatch/features/stopwatch/domain/bloc/stopwatch_bloc.dart';
import 'package:mocktail/mocktail.dart';

class FakeStopwatchBloc extends Fake implements StopwatchBloc {}
