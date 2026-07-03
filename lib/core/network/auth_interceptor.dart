import 'package:dio/dio.dart';

import '../auth/auth_token_storage.dart';
import '../router/app_router.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor({required this.tokenStorage});

  final AuthTokenStorage tokenStorage;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await tokenStorage.readAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      await tokenStorage.clearTokens();
      AppRouter.router.go('/login?expired=true');
    }
    handler.next(err);
  }
}
