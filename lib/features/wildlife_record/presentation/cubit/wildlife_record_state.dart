import 'package:equatable/equatable.dart';

import '../../domain/entities/especie.dart';
import '../../domain/entities/wildlife_record.dart';

sealed class WildlifeRecordState extends Equatable {
  const WildlifeRecordState();

  @override
  List<Object?> get props => [];
}

final class WildlifeRecordInitial extends WildlifeRecordState {
  const WildlifeRecordInitial();
}

final class WildlifeRecordLoadingLocation extends WildlifeRecordState {
  const WildlifeRecordLoadingLocation();
}

final class WildlifeRecordFormEditing extends WildlifeRecordState {
  const WildlifeRecordFormEditing({
    required this.draft,
    this.especies = const [],
    this.isReviewing = false,
    this.validationError,
  });

  final WildlifeRecord draft;
  final List<Especie> especies;
  final bool isReviewing;
  final String? validationError;

  WildlifeRecordFormEditing copyWith({
    WildlifeRecord? draft,
    List<Especie>? especies,
    bool? isReviewing,
    String? validationError,
  }) {
    return WildlifeRecordFormEditing(
      draft: draft ?? this.draft,
      especies: especies ?? this.especies,
      isReviewing: isReviewing ?? this.isReviewing,
      validationError: validationError,
    );
  }

  @override
  List<Object?> get props => [draft, especies, isReviewing, validationError];
}

final class WildlifeRecordUploadingPhotos extends WildlifeRecordState {
  const WildlifeRecordUploadingPhotos();
}

final class WildlifeRecordSubmitting extends WildlifeRecordState {
  const WildlifeRecordSubmitting();
}

final class WildlifeRecordSuccess extends WildlifeRecordState {
  const WildlifeRecordSuccess({required this.record});

  final WildlifeRecord record;

  @override
  List<Object?> get props => [record];
}

final class WildlifeRecordError extends WildlifeRecordState {
  const WildlifeRecordError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
