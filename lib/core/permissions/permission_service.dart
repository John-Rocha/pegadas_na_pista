import 'package:permission_handler/permission_handler.dart';

import '../errors/failures.dart';
import '../result.dart';

class PermissionService {
  Future<Result<void>> requestLocationPermission() =>
      _request(Permission.locationWhenInUse);

  Future<Result<void>> requestCameraPermission() => _request(Permission.camera);

  Future<Result<void>> _request(Permission permission) async {
    final status = await permission.request();
    if (status.isGranted) {
      return const Success(null);
    }
    return Error(PermissionFailure('$permission denied: $status'));
  }
}
