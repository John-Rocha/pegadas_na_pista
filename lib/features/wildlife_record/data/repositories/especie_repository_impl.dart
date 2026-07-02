import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/result.dart';
import '../../domain/entities/especie.dart';
import '../../domain/repositories/especie_repository.dart';
import '../datasources/especie_remote_datasource.dart';

class EspecieRepositoryImpl implements EspecieRepository {
  EspecieRepositoryImpl({required this.remoteDataSource});

  final EspecieRemoteDataSource remoteDataSource;

  @override
  Future<Result<List<Especie>>> getEspecies() async {
    try {
      final especies = await remoteDataSource.getEspecies();
      return Success(especies);
    } on ServerException catch (e) {
      return Error(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Error(NetworkFailure(e.message));
    } catch (e) {
      return Error(UnexpectedFailure(e.toString()));
    }
  }
}
