class LocationException implements Exception {
  LocationException(this.message);

  final String message;
}

class PermissionException implements Exception {
  PermissionException(this.message);

  final String message;
}

class ServerException implements Exception {
  ServerException(this.message);

  final String message;
}

class NetworkException implements Exception {
  NetworkException(this.message);

  final String message;
}

class UnauthorizedException implements Exception {
  UnauthorizedException(this.message);

  final String message;
}

class ValidationException implements Exception {
  ValidationException(this.message);

  final String message;
}
