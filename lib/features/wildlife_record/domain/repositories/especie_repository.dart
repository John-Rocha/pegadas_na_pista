import '../../../../core/result.dart';
import '../entities/especie.dart';

abstract class EspecieRepository {
  Future<Result<List<Especie>>> getEspecies();
}
