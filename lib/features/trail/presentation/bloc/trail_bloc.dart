import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/usecases/delete_trail.dart';
import '../../domain/usecases/get_trails.dart';
import 'trail_event.dart';
import 'trail_state.dart';

class TrailBloc extends Bloc<TrailEvent, TrailState> {
  TrailBloc({required this.getTrails, required this.deleteTrail})
    : super(const TrailInitial()) {
    on<LoadTrails>(_onLoadTrails);
    on<DeleteTrailRequested>(_onDeleteTrailRequested);
  }

  final GetTrails getTrails;
  final DeleteTrail deleteTrail;

  Future<void> _onLoadTrails(LoadTrails event, Emitter<TrailState> emit) async {
    emit(const TrailLoadInProgress());
    final result = await getTrails(const NoParams());
    switch (result) {
      case Success(value: final trails):
        emit(TrailLoadSuccess(trails: trails));
      case Error(failure: final failure):
        emit(TrailLoadFailure(message: failure.message));
    }
  }

  Future<void> _onDeleteTrailRequested(
    DeleteTrailRequested event,
    Emitter<TrailState> emit,
  ) async {
    final result = await deleteTrail(
      DeleteTrailParams(trailId: event.trailId),
    );
    switch (result) {
      case Success():
        add(const LoadTrails());
      case Error(failure: final failure):
        emit(TrailLoadFailure(message: failure.message));
    }
  }
}
