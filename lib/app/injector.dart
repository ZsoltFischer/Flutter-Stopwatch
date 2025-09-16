// infrastructure/dependency_injection.dart
import 'package:get_it/get_it.dart';
import 'package:utils/utils.dart';

final GetIt getIt = GetIt.instance;

/// Register dependencies in the service locator
Future<void> configureDependencies() async {
  getIt.registerSingleton<CustomLogger>(CustomLogger());
}
