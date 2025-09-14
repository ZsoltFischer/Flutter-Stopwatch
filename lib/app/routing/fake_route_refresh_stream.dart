// Dummy usage only, for showcasing purposes
// ignore_for_file: deprecated_member_use_from_same_package,
// avoid_positional_boolean_parameters

import 'dart:async';

class FakeRouteRefreshStream {
  @Deprecated('Remove once authentication is implemented')
  static final authController = StreamController<String?>.broadcast();

  @Deprecated('Remove once connectivity is implemented')
  static final connectivityController = StreamController<bool?>.broadcast();

  /// Stream getters
  static Stream<String?> get authStream => authController.stream;
  static Stream<bool?> get connectivityStream => connectivityController.stream;

  /// Utility methods to emit dummy values
  static void emitAuth(String? value) => authController.add(value);

  /// Ignored because dummy usage only
  // ignore: avoid_positional_boolean_parameters
  static void emitConnectivity(bool? value) =>
      connectivityController.add(value);

  /// Call this on app shutdown or test cleanup
  static Future<void> dispose() async {
    await authController.close();
    await connectivityController.close();
  }
}
