import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pegadas_na_pista/core/errors/failures.dart';
import 'package:pegadas_na_pista/core/result.dart';
import 'package:pegadas_na_pista/features/auth/domain/entities/authenticated_user.dart';
import 'package:pegadas_na_pista/features/auth/domain/repositories/auth_repository.dart';
import 'package:pegadas_na_pista/features/auth/domain/usecases/get_current_user.dart';
import 'package:pegadas_na_pista/features/auth/domain/usecases/login.dart';
import 'package:pegadas_na_pista/features/auth/domain/usecases/logout.dart';
import 'package:pegadas_na_pista/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:pegadas_na_pista/features/auth/presentation/cubit/auth_state.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository repository;

  const user = AuthenticatedUser(
    id: 'u1',
    nome: 'Jane',
    email: 'jane@email.com',
    perfil: 'usuario',
  );

  setUp(() {
    repository = MockAuthRepository();
  });

  AuthCubit buildCubit() => AuthCubit(
    login: Login(repository: repository),
    logout: Logout(repository: repository),
    getCurrentUser: GetCurrentUser(repository: repository),
  );

  blocTest<AuthCubit, AuthState>(
    'emits [AuthLoading, AuthAuthenticated] on successful signIn',
    setUp: () => when(
      () => repository.login(
        email: any(named: 'email'),
        senha: any(named: 'senha'),
      ),
    ).thenAnswer((_) async => const Success(user)),
    build: buildCubit,
    act: (cubit) => cubit.signIn(email: 'jane@email.com', senha: '123456'),
    expect: () => [const AuthLoading(), const AuthAuthenticated(user: user)],
  );

  blocTest<AuthCubit, AuthState>(
    'emits [AuthLoading, AuthFailure] on failed signIn',
    setUp: () =>
        when(
          () => repository.login(
            email: any(named: 'email'),
            senha: any(named: 'senha'),
          ),
        ).thenAnswer(
          (_) async => const Error(ServerFailure('Credenciais inválidas.')),
        ),
    build: buildCubit,
    act: (cubit) => cubit.signIn(email: 'jane@email.com', senha: 'wrong'),
    expect: () => [const AuthLoading(), isA<AuthError>()],
  );

  blocTest<AuthCubit, AuthState>(
    'emits AuthUnauthenticated after signOut',
    setUp: () => when(
      () => repository.logout(),
    ).thenAnswer((_) async => const Success(null)),
    build: buildCubit,
    act: (cubit) => cubit.signOut(),
    expect: () => [const AuthUnauthenticated()],
  );

  blocTest<AuthCubit, AuthState>(
    'emits AuthAuthenticated when checkAuthStatus finds cached user',
    setUp: () => when(
      () => repository.getCurrentUser(),
    ).thenAnswer((_) async => const Success(user)),
    build: buildCubit,
    act: (cubit) => cubit.checkAuthStatus(),
    expect: () => [const AuthAuthenticated(user: user)],
  );

  blocTest<AuthCubit, AuthState>(
    'emits AuthUnauthenticated when checkAuthStatus finds no cached user',
    setUp: () => when(
      () => repository.getCurrentUser(),
    ).thenAnswer((_) async => const Success(null)),
    build: buildCubit,
    act: (cubit) => cubit.checkAuthStatus(),
    expect: () => [const AuthUnauthenticated()],
  );
}
