import 'package:equatable/equatable.dart';

import '../../../../core/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/trail_repository.dart';

class DeleteTrailParams extends Equatable {
  const DeleteTrailParams({required this.trailId});

  final int trailId;

  @override
  List<Object?> get props => [trailId];
}

class DeleteTrail implements UseCase<void, DeleteTrailParams> {
  DeleteTrail({required this.repository});

  final TrailRepository repository;

  @override
  Future<Result<void>> call(DeleteTrailParams params) =>
      repository.deleteTrail(params.trailId);
}
