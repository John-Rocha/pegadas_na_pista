import 'package:equatable/equatable.dart';

import '../../../../core/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/trail.dart';
import '../repositories/trail_repository.dart';

class StartTrailParams extends Equatable {
  const StartTrailParams({required this.name});

  final String name;

  @override
  List<Object?> get props => [name];
}

class StartTrail implements UseCase<Trail, StartTrailParams> {
  StartTrail({required this.repository});

  final TrailRepository repository;

  @override
  Future<Result<Trail>> call(StartTrailParams params) =>
      repository.startTrail(params.name);
}
