import 'package:equatable/equatable.dart';

sealed class TrailEvent extends Equatable {
  const TrailEvent();

  @override
  List<Object?> get props => [];
}

final class LoadTrails extends TrailEvent {
  const LoadTrails();
}

final class DeleteTrailRequested extends TrailEvent {
  const DeleteTrailRequested({required this.trailId});

  final int trailId;

  @override
  List<Object?> get props => [trailId];
}
