import '../../../../core/result.dart';
import '../entities/authenticated_user.dart';

abstract class AuthRepository {
  Future<Result<AuthenticatedUser>> login({
    required String email,
    required String senha,
  });

  Future<Result<void>> logout();

  Future<Result<AuthenticatedUser?>> getCurrentUser();
}
