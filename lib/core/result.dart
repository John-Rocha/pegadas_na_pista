import 'errors/failures.dart';

/// Lightweight Either-style wrapper for operations that can fail.
/// Use pattern matching (`switch`/`case`) to unwrap: exhaustive over
/// [Success] and [Error] since this class is sealed.
sealed class Result<T> {
  const Result();
}

final class Success<T> extends Result<T> {
  const Success(this.value);

  final T value;
}

final class Error<T> extends Result<T> {
  const Error(this.failure);

  final Failure failure;
}
