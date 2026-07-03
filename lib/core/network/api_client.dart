import 'package:dio/dio.dart';

const kApiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'https://api.pegadasnapista.example.com',
);

class ApiClient {
  ApiClient({required this.baseUrl});

  final String baseUrl;

  Dio get dio => Dio(BaseOptions(baseUrl: baseUrl));
}
