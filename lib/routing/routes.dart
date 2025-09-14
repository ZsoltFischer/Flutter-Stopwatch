/// All the supported routes in the app.
/// By using an enum, we route by name using this syntax:
/// ```dart
/// context.goNamed(AppRoute.stopwatch.path)
/// ```
enum AppRoutes {
  stopwatch(path: '/'),
  profile(path: '/profile');

  const AppRoutes({required this.path});

  final String path;
}
