class FakeStopwatch implements Stopwatch {
  int _elapsedMilliseconds = 0;
  bool _isRunning = false;

  @override
  int get elapsedMilliseconds => _elapsedMilliseconds;

  @override
  bool get isRunning => _isRunning;

  void advance(int milliseconds) {
    if (_isRunning) {
      _elapsedMilliseconds += milliseconds;
    }
  }

  @override
  void start() => _isRunning = true;

  @override
  void stop() => _isRunning = false;

  @override
  void reset() {
    _elapsedMilliseconds = 0;
  }

  // Minimal implementation for required members
  @override
  Duration get elapsed => Duration(milliseconds: _elapsedMilliseconds);
  @override
  int get elapsedMicroseconds => _elapsedMilliseconds * 1000;
  @override
  int get elapsedTicks => throw UnimplementedError();
  @override
  int get frequency => throw UnimplementedError();
}
