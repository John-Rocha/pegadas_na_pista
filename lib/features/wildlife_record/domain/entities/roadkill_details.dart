import 'package:equatable/equatable.dart';

class RoadkillDetails extends Equatable {
  const RoadkillDetails({
    this.carcassCondition,
    this.animalPosition,
    this.roadDirection,
    this.roadLane,
  });

  final String? carcassCondition;
  final String? animalPosition;
  final String? roadDirection;
  final String? roadLane;

  @override
  List<Object?> get props => [
    carcassCondition,
    animalPosition,
    roadDirection,
    roadLane,
  ];
}
