import '../../domain/entities/trail.dart';
import '../../domain/entities/trail_point.dart';

class TrailModel extends Trail {
  const TrailModel({
    super.id,
    required super.name,
    required super.createdAt,
    super.points,
  });

  factory TrailModel.fromMap(
    Map<String, Object?> map, {
    List<TrailPoint> points = const [],
  }) => TrailModel(
    id: map['id'] as int?,
    name: map['name'] as String,
    createdAt: DateTime.parse(map['created_at'] as String),
    points: points,
  );

  Map<String, Object?> toMap() => {
    if (id != null) 'id': id,
    'name': name,
    'created_at': createdAt.toIso8601String(),
  };
}
