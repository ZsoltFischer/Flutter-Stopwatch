import 'package:stopwatch/features/stopwatch/data/model/lap_model.dart';

class LapLocalDataSource {
  Future<void> saveSession(List<LapModel> lap) async {
    // Implementation to save lap locally
  }

  Future<List<LapModel>> getSession() async {
    // Implementation to retrieve laps from local storage
    return [];
  }
}
