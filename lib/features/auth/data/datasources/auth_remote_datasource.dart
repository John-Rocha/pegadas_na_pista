import 'package:dio/dio.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/login_request_model.dart';
import '../models/login_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponseModel> login(LoginRequestModel request);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl({required this.dio});

  final Dio dio;

  @override
  Future<LoginResponseModel> login(LoginRequestModel request) async {
    try {
      final response = await dio.post(
        '/api/auth/login',
        data: request.toJson(),
      );
      return LoginResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      if (e.response != null) {
        throw ServerException(
          (e.response?.data as Map?)?['message'] as String? ??
              'Erro no servidor.',
        );
      }
      throw NetworkException(e.message ?? 'Sem conexão.');
    }
  }
}
