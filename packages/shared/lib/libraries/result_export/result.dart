/// Result type for functional error handling without exceptions.
library;

sealed class Result<S, F> {
  const Result();

  bool get isSuccess => this is Success<S, F>;
  bool get isFailure => this is Failure<S, F>;

  T fold<T>(T Function(S value) onSuccess, T Function(F error) onFailure);
  Result<T, F> map<T>(T Function(S value) transform);
  Result<S, T> mapFailure<T>(T Function(F error) transform);
  S getOrThrow();
  S getOrElse(S defaultValue);
}

final class Success<S, F> extends Result<S, F> {
  final S value;

  const Success(this.value);

  @override
  T fold<T>(T Function(S value) onSuccess, T Function(F error) onFailure) {
    return onSuccess(value);
  }

  @override
  Result<T, F> map<T>(T Function(S value) transform) {
    return Success(transform(value));
  }

  @override
  Result<S, T> mapFailure<T>(T Function(F error) transform) {
    return Success(value);
  }

  @override
  S getOrThrow() => value;

  @override
  S getOrElse(S defaultValue) => value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Success<S, F> && other.value == value);

  @override
  int get hashCode => value.hashCode;
}

final class Failure<S, F> extends Result<S, F> {
  final F error;

  const Failure(this.error);

  @override
  T fold<T>(T Function(S value) onSuccess, T Function(F error) onFailure) {
    return onFailure(error);
  }

  @override
  Result<T, F> map<T>(T Function(S value) transform) {
    return Failure(error);
  }

  @override
  Result<S, T> mapFailure<T>(T Function(F error) transform) {
    return Failure(transform(error));
  }

  @override
  S getOrThrow() {
    throw StateError('Cannot get value from Failure: $error');
  }

  @override
  S getOrElse(S defaultValue) => defaultValue;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Failure<S, F> && other.error == error);

  @override
  int get hashCode => error.hashCode;
}
