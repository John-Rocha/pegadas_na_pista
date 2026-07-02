import '../../domain/entities/trail_point.dart';

class TrailPointModel extends TrailPoint {
  const TrailPointModel({
    this.id,
    this.trailId,
    required super.latitude,
    required super.longitude,
    required super.timestamp,
    super.photoPath,
  });

  final int? id;
  final int? trailId;

  factory TrailPointModel.fromMap(Map<String, Object?> map) => TrailPointModel(
    id: map['id'] as int?,
    trailId: map['trail_id'] as int?,
    latitude: map['latitude'] as double,
    longitude: map['longitude'] as double,
    timestamp: DateTime.parse(map['timestamp'] as String),
    photoPath: map['photo_path'] as String?,
  );

  factory TrailPointModel.fromEntity(TrailPoint point, {int? trailId}) =>
      TrailPointModel(
        trailId: trailId,
        latitude: point.latitude,
        longitude: point.longitude,
        timestamp: point.timestamp,
        photoPath: point.photoPath,
      );

  Map<String, Object?> toMap() => {
    if (id != null) 'id': id,
    if (trailId != null) 'trail_id': trailId,
    'latitude': latitude,
    'longitude': longitude,
    'timestamp': timestamp.toIso8601String(),
    'photo_path': photoPath,
  };
}
