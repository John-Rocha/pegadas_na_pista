import 'package:equatable/equatable.dart';

import '../../domain/entities/trail.dart';

sealed class TrailState extends Equatable {
  const TrailState();

  @override
  List<Object?> get props => [];
}

final class TrailInitial extends TrailState {
  const TrailInitial();
}

final class TrailLoadInProgress extends TrailState {
  const TrailLoadInProgress();
}

final class TrailLoadSuccess extends TrailState {
  const TrailLoadSuccess({required this.trails});

  final List<Trail> trails;

  @override
  List<Object?> get props => [trails];
}

final class TrailLoadFailure extends TrailState {
  const TrailLoadFailure({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
