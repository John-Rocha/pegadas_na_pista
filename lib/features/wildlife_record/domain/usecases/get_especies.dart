import '../../../../core/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/especie.dart';
import '../repositories/especie_repository.dart';

class GetEspecies implements UseCase<List<Especie>, NoParams> {
  GetEspecies({required this.repository});

  final EspecieRepository repository;

  @override
  Future<Result<List<Especie>>> call(NoParams params) =>
      repository.getEspecies();
}
