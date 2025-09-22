/// All the supported routes in the app.
/// By using an enum, we route by name using this syntax:
/// ```dart
/// context.goNamed(Routes.stopwatch.path)
/// ```
enum Routes {
  stopwatch(path: '/'),
  profile(path: '/profile');

  const Routes({required this.path});

  final String path;
}
