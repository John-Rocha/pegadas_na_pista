import '../../../../core/errors/failures.dart';
import '../../../../core/result.dart';
import '../../domain/entities/record_photo.dart';
import '../../domain/entities/wildlife_record.dart';
import '../../domain/repositories/wildlife_record_repository.dart';
import '../datasources/wildlife_record_local_datasource.dart';
import '../models/wildlife_record_model.dart';

class WildlifeRecordRepositoryImpl implements WildlifeRecordRepository {
  WildlifeRecordRepositoryImpl({required this.localDataSource});

  final WildlifeRecordLocalDataSource localDataSource;

  @override
  Future<Result<WildlifeRecord>> createRecord(WildlifeRecord record) async {
    try {
      final model = WildlifeRecordModel.fromEntity(record);
      final json = await localDataSource.createRecord(model);
      return Success(WildlifeRecordModel.fromCreateResponse(record, json));
    } catch (e) {
      return Error(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Result<RecordPhoto>> uploadPhoto({
    required String localPath,
    required String tipoFoto,
    String? registroId,
  }) async {
    try {
      final photo = await localDataSource.uploadPhoto(
        localPath: localPath,
        tipoFoto: tipoFoto,
        registroId: registroId,
      );
      return Success(photo);
    } catch (e) {
      return Error(DatabaseFailure(e.toString()));
    }
  }
}
