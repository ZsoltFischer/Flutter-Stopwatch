class FakeRouteRefreshStream {
  @Deprecated('Remove once authentication is implemented')
  static const authStream = Stream<String?>.empty();

  @Deprecated('Remove once connectivity is implemented')
  static const connectivityStream = Stream<bool?>.empty();
}
