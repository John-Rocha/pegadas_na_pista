import 'package:equatable/equatable.dart';

class SightingDetails extends Equatable {
  const SightingDetails({
    this.quantity = 1,
    this.observedBehavior,
    this.approximateDistance,
    this.animalAlive = true,
  });

  final int quantity;
  final String? observedBehavior;
  final double? approximateDistance;
  final bool animalAlive;

  @override
  List<Object?> get props => [
    quantity,
    observedBehavior,
    approximateDistance,
    animalAlive,
  ];
}
