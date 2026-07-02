import '../../../../core/result.dart';
import '../entities/trail.dart';
import '../entities/trail_point.dart';

abstract class TrailRepository {
  Future<Result<List<Trail>>> getTrails();

  Future<Result<Trail>> startTrail(String name);

  Future<Result<void>> addTrailPoint(int trailId, TrailPoint point);

  Future<Result<void>> deleteTrail(int trailId);
}
