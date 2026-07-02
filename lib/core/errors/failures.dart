sealed class Failure {
  const Failure(this.message);

  final String message;
}

final class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message);
}

final class LocationFailure extends Failure {
  const LocationFailure(super.message);
}

final class PermissionFailure extends Failure {
  const PermissionFailure(super.message);
}

final class UnexpectedFailure extends Failure {
  const UnexpectedFailure(super.message);
}
