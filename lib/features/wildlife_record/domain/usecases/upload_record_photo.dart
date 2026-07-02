import 'package:equatable/equatable.dart';

import '../../../../core/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/record_photo.dart';
import '../repositories/wildlife_record_repository.dart';

class UploadRecordPhotoParams extends Equatable {
  const UploadRecordPhotoParams({
    required this.localPath,
    required this.tipoFoto,
    this.registroId,
  });

  final String localPath;
  final String tipoFoto;
  final String? registroId;

  @override
  List<Object?> get props => [localPath, tipoFoto, registroId];
}

class UploadRecordPhoto
    implements UseCase<RecordPhoto, UploadRecordPhotoParams> {
  UploadRecordPhoto({required this.repository});

  final WildlifeRecordRepository repository;

  @override
  Future<Result<RecordPhoto>> call(UploadRecordPhotoParams params) =>
      repository.uploadPhoto(
        localPath: params.localPath,
        tipoFoto: params.tipoFoto,
        registroId: params.registroId,
      );
}
