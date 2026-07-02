import 'package:dio/dio.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/especie_model.dart';

abstract class EspecieRemoteDataSource {
  Future<List<EspecieModel>> getEspecies();
}

class EspecieRemoteDataSourceImpl implements EspecieRemoteDataSource {
  EspecieRemoteDataSourceImpl({required this.dio});

  final Dio dio;

  List<EspecieModel>? _cache;

  @override
  Future<List<EspecieModel>> getEspecies() async {
    final cached = _cache;
    if (cached != null) return cached;
    try {
      final response = await dio.get('/api/especies');
      final especies = (response.data as List)
          .map((e) => EspecieModel.fromJson(e as Map<String, dynamic>))
          .toList();
      _cache = especies;
      return especies;
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
