import 'package:equatable/equatable.dart';

class TrailPoint extends Equatable {
  const TrailPoint({
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    this.photoPath,
  });

  final double latitude;
  final double longitude;
  final DateTime timestamp;
  final String? photoPath;

  @override
  List<Object?> get props => [latitude, longitude, timestamp, photoPath];
}
