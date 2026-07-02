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

final class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

final class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

final class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

final class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}
