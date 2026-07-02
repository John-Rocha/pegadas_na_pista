import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/location/location_service.dart';
import '../../../../core/media/media_service.dart';
import '../../../../core/permissions/permission_service.dart';
import '../../../../core/result.dart';
import '../../domain/entities/trail.dart';
import '../../domain/entities/trail_point.dart';
import '../../domain/usecases/add_trail_point.dart';
import '../../domain/usecases/start_trail.dart';
import 'trail_recording_state.dart';

class TrailRecordingCubit extends Cubit<TrailRecordingState> {
  TrailRecordingCubit({
    required this.startTrail,
    required this.addTrailPoint,
    required this.locationService,
    required this.mediaService,
    required this.permissionService,
  }) : super(const TrailRecordingIdle());

  final StartTrail startTrail;
  final AddTrailPoint addTrailPoint;
  final LocationService locationService;
  final MediaService mediaService;
  final PermissionService permissionService;

  Future<void> startRecording(String name) async {
    final permissionResult = await permissionService
        .requestLocationPermission();
    if (permissionResult case Error(:final failure)) {
      emit(TrailRecordingError(message: failure.message));
      return;
    }

    final startResult = await startTrail(StartTrailParams(name: name));
    switch (startResult) {
      case Success(value: final trail):
        emit(TrailRecordingInProgress(trail: trail));
        await _captureCurrentPoint(trail);
      case Error(failure: final failure):
        emit(TrailRecordingError(message: failure.message));
    }
  }

  Future<void> capturePoint({bool withPhoto = false}) async {
    final currentState = state;
    if (currentState is! TrailRecordingInProgress) return;
    await _captureCurrentPoint(currentState.trail, withPhoto: withPhoto);
  }

  Future<void> _captureCurrentPoint(
    Trail trail, {
    bool withPhoto = false,
  }) async {
    final positionResult = await locationService.getCurrentPosition();
    if (positionResult case Error(:final failure)) {
      emit(TrailRecordingError(message: failure.message));
      return;
    }
    final position = (positionResult as Success<Position>).value;

    String? photoPath;
    if (withPhoto) {
      final photoResult = await mediaService.captureTrailPhoto();
      if (photoResult case Success(value: final path)) {
        photoPath = path;
      }
    }

    final point = TrailPoint(
      latitude: position.latitude,
      longitude: position.longitude,
      timestamp: DateTime.now(),
      photoPath: photoPath,
    );

    final addResult = await addTrailPoint(
      AddTrailPointParams(trailId: trail.id!, point: point),
    );
    switch (addResult) {
      case Success():
        emit(
          TrailRecordingInProgress(
            trail: trail.copyWith(points: [...trail.points, point]),
          ),
        );
      case Error(failure: final failure):
        emit(TrailRecordingError(message: failure.message));
    }
  }

  void finishRecording() {
    emit(const TrailRecordingIdle());
  }
}
