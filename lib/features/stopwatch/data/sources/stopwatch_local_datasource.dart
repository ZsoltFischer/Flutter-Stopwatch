import 'package:shared_preferences/shared_preferences.dart';
import 'package:stopwatch/features/stopwatch/data/model/lap_model.dart';
import 'package:stopwatch/features/stopwatch/domain/entity/lap_entity.dart';
import 'package:utils/utils.dart';

class StopwatchLocalDataSource {
  // Existing methods...

  Future<Result<List<LapEntity>, Exception>> getLaps() async {
    try {
      /// Save to shared preferences or local database
      //!TODO: Implement actual fetching logic with shared preferences

      return Success([]);
    } catch (e) {
      return Failure(Exception('Failed to fetch laps: $e'));
    }
  }

  Future<Result<void, Exception>> saveLap(LapEntity lap) async {
    try {
      final lapModel = LapModel.fromEntity(lap); // Convert entity to model

      /// Save to shared preferences or local database
      //!TODO: Implement actual saving logic with shared preferences

      return const Success(null);
    } catch (e) {
      return Failure(Exception('Failed to save lap: $e'));
    }
  }
}
