import 'package:dio/dio.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/record_photo_model.dart';
import '../models/wildlife_record_model.dart';

abstract class WildlifeRecordRemoteDataSource {
  Future<Map<String, dynamic>> createRecord(WildlifeRecordModel record);

  Future<RecordPhotoModel> uploadPhoto({
    required String localPath,
    required String tipoFoto,
    String? registroId,
  });
}

class WildlifeRecordRemoteDataSourceImpl
    implements WildlifeRecordRemoteDataSource {
  WildlifeRecordRemoteDataSourceImpl({required this.dio});

  final Dio dio;

  @override
  Future<Map<String, dynamic>> createRecord(
    WildlifeRecordModel record,
  ) async {
    try {
      final response = await dio.post(
        '/api/registros-fauna',
        data: record.toJson(),
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _mapException(e);
    }
  }

  @override
  Future<RecordPhotoModel> uploadPhoto({
    required String localPath,
    required String tipoFoto,
    String? registroId,
  }) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(localPath),
        'idRegistro': ?registroId,
        'tipoFoto': tipoFoto,
      });
      final response = await dio.post(
        '/api/registros-fauna/fotos/upload',
        data: formData,
      );
      final json = response.data as Map<String, dynamic>;
      return RecordPhotoModel(
        urlFoto: json['urlFoto'] as String,
        tipoFoto: tipoFoto,
      );
    } on DioException catch (e) {
      throw _mapException(e);
    }
  }

  Exception _mapException(DioException e) {
    if (e.response != null) {
      return ServerException(
        (e.response?.data as Map?)?['message'] as String? ??
            'Erro no servidor.',
      );
    }
    return NetworkException(e.message ?? 'Sem conexão.');
  }
}
