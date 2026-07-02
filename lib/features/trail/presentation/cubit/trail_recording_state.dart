import 'package:equatable/equatable.dart';

import '../../domain/entities/trail.dart';

sealed class TrailRecordingState extends Equatable {
  const TrailRecordingState();

  @override
  List<Object?> get props => [];
}

final class TrailRecordingIdle extends TrailRecordingState {
  const TrailRecordingIdle();
}

final class TrailRecordingInProgress extends TrailRecordingState {
  const TrailRecordingInProgress({required this.trail});

  final Trail trail;

  @override
  List<Object?> get props => [trail];
}

final class TrailRecordingError extends TrailRecordingState {
  const TrailRecordingError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
