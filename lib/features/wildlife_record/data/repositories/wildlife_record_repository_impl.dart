import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/result.dart';
import '../../domain/entities/record_photo.dart';
import '../../domain/entities/wildlife_record.dart';
import '../../domain/repositories/wildlife_record_repository.dart';
import '../datasources/wildlife_record_remote_datasource.dart';
import '../models/wildlife_record_model.dart';

class WildlifeRecordRepositoryImpl implements WildlifeRecordRepository {
  WildlifeRecordRepositoryImpl({required this.remoteDataSource});

  final WildlifeRecordRemoteDataSource remoteDataSource;

  @override
  Future<Result<WildlifeRecord>> createRecord(WildlifeRecord record) async {
    try {
      final model = WildlifeRecordModel.fromEntity(record);
      final json = await remoteDataSource.createRecord(model);
      return Success(WildlifeRecordModel.fromCreateResponse(record, json));
    } on ServerException catch (e) {
      return Error(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Error(NetworkFailure(e.message));
    } catch (e) {
      return Error(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Result<RecordPhoto>> uploadPhoto({
    required String localPath,
    required String tipoFoto,
    String? registroId,
  }) async {
    try {
      final photo = await remoteDataSource.uploadPhoto(
        localPath: localPath,
        tipoFoto: tipoFoto,
        registroId: registroId,
      );
      return Success(photo);
    } on ServerException catch (e) {
      return Error(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Error(NetworkFailure(e.message));
    } catch (e) {
      return Error(UnexpectedFailure(e.toString()));
    }
  }
}
