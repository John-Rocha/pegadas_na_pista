import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/logout.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required this.login,
    required this.logout,
    required this.getCurrentUser,
  }) : super(const AuthInitial());

  final Login login;
  final Logout logout;
  final GetCurrentUser getCurrentUser;

  Future<void> checkAuthStatus() async {
    final result = await getCurrentUser(const NoParams());
    switch (result) {
      case Success(value: final user?):
        emit(AuthAuthenticated(user: user));
      case Success():
        emit(const AuthUnauthenticated());
      case Error(failure: final failure):
        emit(AuthError(message: failure.message));
    }
  }

  Future<void> signIn({required String email, required String senha}) async {
    emit(const AuthLoading());
    final result = await login(LoginParams(email: email, senha: senha));
    switch (result) {
      case Success(value: final user):
        emit(AuthAuthenticated(user: user));
      case Error(failure: final failure):
        emit(AuthError(message: failure.message));
    }
  }

  Future<void> signOut() async {
    await logout(const NoParams());
    emit(const AuthUnauthenticated());
  }
}
