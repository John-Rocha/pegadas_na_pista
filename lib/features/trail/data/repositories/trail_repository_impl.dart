import '../../../../core/errors/failures.dart';
import '../../../../core/result.dart';
import '../../domain/entities/trail.dart';
import '../../domain/entities/trail_point.dart';
import '../../domain/repositories/trail_repository.dart';
import '../datasources/trail_local_data_source.dart';
import '../models/trail_point_model.dart';

class TrailRepositoryImpl implements TrailRepository {
  TrailRepositoryImpl({required this.localDataSource});

  final TrailLocalDataSource localDataSource;

  @override
  Future<Result<List<Trail>>> getTrails() async {
    try {
      final trails = await localDataSource.getTrails();
      return Success(trails);
    } catch (e) {
      return Error(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Result<Trail>> startTrail(String name) async {
    try {
      final trail = await localDataSource.startTrail(name);
      return Success(trail);
    } catch (e) {
      return Error(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> addTrailPoint(int trailId, TrailPoint point) async {
    try {
      await localDataSource.addTrailPoint(
        trailId,
        TrailPointModel.fromEntity(point),
      );
      return const Success(null);
    } catch (e) {
      return Error(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> deleteTrail(int trailId) async {
    try {
      await localDataSource.deleteTrail(trailId);
      return const Success(null);
    } catch (e) {
      return Error(DatabaseFailure(e.toString()));
    }
  }
}
