import 'package:equatable/equatable.dart';

import '../../../../core/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/authenticated_user.dart';
import '../repositories/auth_repository.dart';

class LoginParams extends Equatable {
  const LoginParams({required this.email, required this.senha});

  final String email;
  final String senha;

  @override
  List<Object?> get props => [email, senha];
}

class Login implements UseCase<AuthenticatedUser, LoginParams> {
  Login({required this.repository});

  final AuthRepository repository;

  @override
  Future<Result<AuthenticatedUser>> call(LoginParams params) =>
      repository.login(email: params.email, senha: params.senha);
}
