import '../../../../core/errors/failures.dart';
import '../../../../core/result.dart';
import '../../domain/entities/especie.dart';
import '../../domain/repositories/especie_repository.dart';
import '../datasources/especie_local_datasource.dart';

class EspecieRepositoryImpl implements EspecieRepository {
  EspecieRepositoryImpl({required this.localDataSource});

  final EspecieLocalDataSource localDataSource;

  @override
  Future<Result<List<Especie>>> getEspecies() async {
    try {
      final especies = await localDataSource.getEspecies();
      return Success(especies);
    } catch (e) {
      return Error(DatabaseFailure(e.toString()));
    }
  }
}
