import '../../../../core/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/trail.dart';
import '../repositories/trail_repository.dart';

class GetTrails implements UseCase<List<Trail>, NoParams> {
  GetTrails({required this.repository});

  final TrailRepository repository;

  @override
  Future<Result<List<Trail>>> call(NoParams params) => repository.getTrails();
}
