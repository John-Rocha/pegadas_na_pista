import 'dart:convert';

import '../../../../core/auth/auth_token_storage.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/result.dart';
import '../../domain/entities/authenticated_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/authenticated_user_model.dart';
import '../models/login_request_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.tokenStorage,
  });

  final AuthRemoteDataSource remoteDataSource;
  final AuthTokenStorage tokenStorage;

  @override
  Future<Result<AuthenticatedUser>> login({
    required String email,
    required String senha,
  }) async {
    try {
      final response = await remoteDataSource.login(
        LoginRequestModel(email: email, senha: senha),
      );
      await tokenStorage.saveTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );
      await tokenStorage.saveUserJson(jsonEncode(response.usuario.toJson()));
      return Success(response.usuario);
    } on ServerException catch (e) {
      return Error(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Error(NetworkFailure(e.message));
    } catch (e) {
      return Error(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await tokenStorage.clearTokens();
      return const Success(null);
    } catch (e) {
      return Error(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Result<AuthenticatedUser?>> getCurrentUser() async {
    try {
      final userJson = await tokenStorage.readUserJson();
      if (userJson == null) return const Success(null);
      return Success(
        AuthenticatedUserModel.fromJson(
          jsonDecode(userJson) as Map<String, dynamic>,
        ),
      );
    } catch (e) {
      return Error(UnexpectedFailure(e.toString()));
    }
  }
}
