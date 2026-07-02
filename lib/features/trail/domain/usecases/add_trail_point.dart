import 'package:equatable/equatable.dart';

import '../../../../core/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/trail_point.dart';
import '../repositories/trail_repository.dart';

class AddTrailPointParams extends Equatable {
  const AddTrailPointParams({required this.trailId, required this.point});

  final int trailId;
  final TrailPoint point;

  @override
  List<Object?> get props => [trailId, point];
}

class AddTrailPoint implements UseCase<void, AddTrailPointParams> {
  AddTrailPoint({required this.repository});

  final TrailRepository repository;

  @override
  Future<Result<void>> call(AddTrailPointParams params) =>
      repository.addTrailPoint(params.trailId, params.point);
}
