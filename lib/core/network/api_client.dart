import 'package:dio/dio.dart';

import 'auth_interceptor.dart';

const kApiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'https://api.pegadasnapista.example.com',
);

class ApiClient {
  ApiClient({required this.baseUrl, required this.authInterceptor});

  final String baseUrl;
  final AuthInterceptor authInterceptor;

  Dio get dio =>
      Dio(BaseOptions(baseUrl: baseUrl))..interceptors.add(authInterceptor);
}
