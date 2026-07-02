import '../../../../core/result.dart';
import '../entities/record_photo.dart';
import '../entities/wildlife_record.dart';

abstract class WildlifeRecordRepository {
  Future<Result<WildlifeRecord>> createRecord(WildlifeRecord record);

  Future<Result<RecordPhoto>> uploadPhoto({
    required String localPath,
    required String tipoFoto,
    String? registroId,
  });
}
