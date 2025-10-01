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

extension ResultMonad<S, E extends Exception> on Result<S, E> {
  Result<U, E> flatMap<U>(Result<U, E> Function(S value) f) {
    if (this is Success<S, E>) {
      final success = this as Success<S, E>;

      return f(success.value); // chain the computation
    } else {
      return this as Failure<U, E>; // propagate failure
    }
  }

  Result<U, E> map<U>(U Function(S value) f) {
    return flatMap((v) => Success<U, E>(f(v)));
  }
}

extension ResultExtensions<S, E extends Exception> on Result<S, E> {
  /// Applies the appropriate function based on whether the result is a success or failure.
  T fold<T>({
    required T Function(S value) onSuccess,
    required T Function(E exception) onFailure,
  }) {
    if (this is Success<S, E>) {
      final success = this as Success<S, E>;

      return onSuccess(success.value);
    } else {
      final failure = this as Failure<S, E>;

      return onFailure(failure.exception);
    }
  }
}

extension AsyncFlatMap on Future<Result<void, Exception>> {
  /// Chains asynchronous operations that return a [Result].
  Future<Result<void, Exception>> flatMap(
    Future<Result<void, Exception>> Function() f,
  ) {
    return then((result) {
      if (result is Success<void, Exception>) {
        return f(); // chain the computation
      } else if (result is Failure<void, Exception>) {
        return result; // propagate failure
      } else {
        throw StateError('Unexpected Result type');
      }
    });
  }
}

extension AsyncResultExtensions<S, E extends Exception>
    on Future<Result<S, E>> {
  /// Applies the appropriate function based on whether the result is a success or failure.
  Future<T> fold<T>({
    required T Function(S value) onSuccess,
    required T Function(E exception) onFailure,
  }) async {
    final result = await this;
    if (result is Success<S, E>) {
      return onSuccess(result.value);
    } else {
      final failure = result as Failure<S, E>;

      return onFailure(failure.exception);
    }
  }
}
