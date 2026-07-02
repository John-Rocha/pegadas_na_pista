import 'package:equatable/equatable.dart';

import '../../../../core/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/wildlife_record.dart';
import '../repositories/wildlife_record_repository.dart';

class CreateWildlifeRecordParams extends Equatable {
  const CreateWildlifeRecordParams({required this.record});

  final WildlifeRecord record;

  @override
  List<Object?> get props => [record];
}

class CreateWildlifeRecord
    implements UseCase<WildlifeRecord, CreateWildlifeRecordParams> {
  CreateWildlifeRecord({required this.repository});

  final WildlifeRecordRepository repository;

  @override
  Future<Result<WildlifeRecord>> call(CreateWildlifeRecordParams params) =>
      repository.createRecord(params.record);
}
