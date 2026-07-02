import '../../../../core/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';

class Logout implements UseCase<void, NoParams> {
  Logout({required this.repository});

  final AuthRepository repository;

  @override
  Future<Result<void>> call(NoParams params) => repository.logout();
}
