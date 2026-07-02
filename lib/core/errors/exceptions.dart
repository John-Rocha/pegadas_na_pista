class LocationException implements Exception {
  LocationException(this.message);

  final String message;
}

class PermissionException implements Exception {
  PermissionException(this.message);

  final String message;
}
