/// Base Result class
/// [S] represents the type of the success value
/// [E] should be [Exception] or a subclass of it
sealed class Result<S, E extends Exception> {
  const Result();
}

/// Represents an event success and holds it as value
final class Success<S, E extends Exception> extends Result<S, E> {
  /// Creates a new [Success] instance
  const Success(this.value);

  /// The exception
  final S value;
}

/// Represents an event failure and holds the exception as value
final class Failure<S, E extends Exception> extends Result<S, E> {
  /// Creates a new [Failure] instance
  const Failure(this.exception);

  /// The exception
  final E exception;
}
