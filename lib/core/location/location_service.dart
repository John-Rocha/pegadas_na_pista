import 'package:geolocator/geolocator.dart';

import '../errors/failures.dart';
import '../result.dart';

class LocationService {
  Future<Result<Position>> getCurrentPosition() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return const Error(LocationFailure('Location services are disabled.'));
      }
      final position = await Geolocator.getCurrentPosition();
      return Success(position);
    } catch (e) {
      return Error(LocationFailure(e.toString()));
    }
  }

  Stream<Position> positionStream({int distanceFilterMeters = 5}) {
    return Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: distanceFilterMeters,
      ),
    );
  }
}
