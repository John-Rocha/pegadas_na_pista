import '../../../../core/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/authenticated_user.dart';
import '../repositories/auth_repository.dart';

class GetCurrentUser implements UseCase<AuthenticatedUser?, NoParams> {
  GetCurrentUser({required this.repository});

  final AuthRepository repository;

  @override
  Future<Result<AuthenticatedUser?>> call(NoParams params) =>
      repository.getCurrentUser();
}
