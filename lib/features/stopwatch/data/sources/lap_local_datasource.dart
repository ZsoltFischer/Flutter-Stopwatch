// ignore_for_file: deprecated_member_use_from_same_package

import 'dart:async';

import 'package:stopwatch/exceptions/app_exception.dart';
import 'package:stopwatch/features/stopwatch/data/models/stopwatch_session_model.dart';
import 'package:utils/utils.dart';

/// Local data source for managing lap data.
class LapLocalDatasource {
  /// Saves a stopwatch session locally.
  FutureOr<Result<void, AppException>> saveSession(
    // ignore: avoid-unused-parameters
    StopwatchSessionModel session,
  ) async {
    //!TODO: Implementation to save lap locally
    return const Success(null);
  }

  FutureOr<Result<StopwatchSessionModel, AppException>?> getSession() async {
    //!TODO: Implementation to retrieve laps from local storage
    return null;
  }
}
