import '../../../../core/database/database_helper.dart';
import '../models/trail_model.dart';
import '../models/trail_point_model.dart';

abstract class TrailLocalDataSource {
  Future<List<TrailModel>> getTrails();

  Future<TrailModel> startTrail(String name);

  Future<void> addTrailPoint(int trailId, TrailPointModel point);

  Future<void> deleteTrail(int trailId);
}

class TrailLocalDataSourceImpl implements TrailLocalDataSource {
  TrailLocalDataSourceImpl({required this.databaseHelper});

  final DatabaseHelper databaseHelper;

  @override
  Future<List<TrailModel>> getTrails() async {
    final db = await databaseHelper.database;
    final trailRows = await db.query('trails', orderBy: 'created_at DESC');

    final trails = <TrailModel>[];
    for (final row in trailRows) {
      final pointRows = await db.query(
        'trail_points',
        where: 'trail_id = ?',
        whereArgs: [row['id']],
        orderBy: 'timestamp ASC',
      );
      final points = pointRows.map(TrailPointModel.fromMap).toList();
      trails.add(TrailModel.fromMap(row, points: points));
    }
    return trails;
  }

  @override
  Future<TrailModel> startTrail(String name) async {
    final db = await databaseHelper.database;
    final trail = TrailModel(name: name, createdAt: DateTime.now());
    final id = await db.insert('trails', trail.toMap());
    return TrailModel.fromMap({...trail.toMap(), 'id': id});
  }

  @override
  Future<void> addTrailPoint(int trailId, TrailPointModel point) async {
    final db = await databaseHelper.database;
    await db.insert(
      'trail_points',
      TrailPointModel.fromEntity(point, trailId: trailId).toMap(),
    );
  }

  @override
  Future<void> deleteTrail(int trailId) async {
    final db = await databaseHelper.database;
    await db.delete(
      'trail_points',
      where: 'trail_id = ?',
      whereArgs: [trailId],
    );
    await db.delete('trails', where: 'id = ?', whereArgs: [trailId]);
  }
}
