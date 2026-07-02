import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pegadas_na_pista/core/auth/auth_token_storage.dart';
import 'package:pegadas_na_pista/core/errors/exceptions.dart';
import 'package:pegadas_na_pista/core/errors/failures.dart';
import 'package:pegadas_na_pista/core/result.dart';
import 'package:pegadas_na_pista/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:pegadas_na_pista/features/auth/data/models/authenticated_user_model.dart';
import 'package:pegadas_na_pista/features/auth/data/models/login_request_model.dart';
import 'package:pegadas_na_pista/features/auth/data/models/login_response_model.dart';
import 'package:pegadas_na_pista/features/auth/data/repositories/auth_repository_impl.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class MockAuthTokenStorage extends Mock implements AuthTokenStorage {}

class FakeLoginRequestModel extends Fake implements LoginRequestModel {}

void main() {
  late MockAuthRemoteDataSource remoteDataSource;
  late MockAuthTokenStorage tokenStorage;
  late AuthRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(FakeLoginRequestModel());
  });

  setUp(() {
    remoteDataSource = MockAuthRemoteDataSource();
    tokenStorage = MockAuthTokenStorage();
    repository = AuthRepositoryImpl(
      remoteDataSource: remoteDataSource,
      tokenStorage: tokenStorage,
    );
  });

  const userModel = AuthenticatedUserModel(
    id: 'u1',
    nome: 'Jane',
    email: 'jane@email.com',
    perfil: 'usuario',
  );

  const response = LoginResponseModel(
    accessToken: 'access',
    refreshToken: 'refresh',
    usuario: userModel,
  );

  group('login', () {
    test('saves tokens and user on success', () async {
      when(
        () => remoteDataSource.login(any()),
      ).thenAnswer((_) async => response);
      when(
        () => tokenStorage.saveTokens(
          accessToken: any(named: 'accessToken'),
          refreshToken: any(named: 'refreshToken'),
        ),
      ).thenAnswer((_) async {});
      when(() => tokenStorage.saveUserJson(any())).thenAnswer((_) async {});

      final result = await repository.login(
        email: 'jane@email.com',
        senha: '123456',
      );

      expect(result, isA<Success<dynamic>>());
      verify(
        () => tokenStorage.saveTokens(
          accessToken: 'access',
          refreshToken: 'refresh',
        ),
      ).called(1);
      verify(() => tokenStorage.saveUserJson(any())).called(1);
    });

    test('returns ServerFailure on ServerException', () async {
      when(
        () => remoteDataSource.login(any()),
      ).thenThrow(ServerException('Credenciais inválidas.'));

      final result = await repository.login(
        email: 'jane@email.com',
        senha: 'wrong',
      );

      expect((result as Error).failure, isA<ServerFailure>());
    });

    test('returns NetworkFailure on NetworkException', () async {
      when(
        () => remoteDataSource.login(any()),
      ).thenThrow(NetworkException('Sem conexão.'));

      final result = await repository.login(
        email: 'jane@email.com',
        senha: '123456',
      );

      expect((result as Error).failure, isA<NetworkFailure>());
    });
  });

  group('logout', () {
    test('clears tokens', () async {
      when(() => tokenStorage.clearTokens()).thenAnswer((_) async {});

      final result = await repository.logout();

      expect(result, isA<Success<void>>());
      verify(() => tokenStorage.clearTokens()).called(1);
    });
  });

  group('getCurrentUser', () {
    test('returns null when no cached user', () async {
      when(() => tokenStorage.readUserJson()).thenAnswer((_) async => null);

      final result = await repository.getCurrentUser();

      expect(result, isA<Success<dynamic>>());
      expect((result as Success).value, isNull);
    });

    test('returns cached user when present', () async {
      when(() => tokenStorage.readUserJson()).thenAnswer(
        (_) async =>
            '{"idUsuario":"u1","nome":"Jane","email":"jane@email.com","perfil":"usuario"}',
      );

      final result = await repository.getCurrentUser();

      expect(result, isA<Success<dynamic>>());
    });
  });
}
