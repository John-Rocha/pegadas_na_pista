import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pegadas_na_pista/core/result.dart';
import 'package:pegadas_na_pista/features/auth/domain/entities/authenticated_user.dart';
import 'package:pegadas_na_pista/features/auth/domain/repositories/auth_repository.dart';
import 'package:pegadas_na_pista/features/auth/domain/usecases/login.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository repository;
  late Login usecase;

  setUp(() {
    repository = MockAuthRepository();
    usecase = Login(repository: repository);
  });

  const user = AuthenticatedUser(
    id: 'u1',
    nome: 'Jane',
    email: 'jane@email.com',
    perfil: 'usuario',
  );

  test('delegates to repository.login with given credentials', () async {
    when(
      () => repository.login(email: 'jane@email.com', senha: '123456'),
    ).thenAnswer((_) async => const Success(user));

    final result = await usecase(
      const LoginParams(email: 'jane@email.com', senha: '123456'),
    );

    expect(result, isA<Success<AuthenticatedUser>>());
    verify(
      () => repository.login(email: 'jane@email.com', senha: '123456'),
    ).called(1);
  });
}
