import 'package:equatable/equatable.dart';

import 'trail_point.dart';

class Trail extends Equatable {
  const Trail({
    this.id,
    required this.name,
    required this.createdAt,
    this.points = const [],
  });

  final int? id;
  final String name;
  final DateTime createdAt;
  final List<TrailPoint> points;

  Trail copyWith({
    int? id,
    String? name,
    DateTime? createdAt,
    List<TrailPoint>? points,
  }) {
    return Trail(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      points: points ?? this.points,
    );
  }

  @override
  List<Object?> get props => [id, name, createdAt, points];
}
