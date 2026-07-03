import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/location/location_service.dart';
import '../../../../core/media/media_service.dart';
import '../../../../core/permissions/permission_service.dart';
import '../../../../core/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/especie.dart';
import '../../domain/entities/record_photo.dart';
import '../../domain/entities/wildlife_record.dart';
import '../../domain/entities/wildlife_record_type.dart';
import '../../domain/usecases/create_wildlife_record.dart';
import '../../domain/usecases/get_especies.dart';
import '../../domain/usecases/upload_record_photo.dart';
import 'wildlife_record_state.dart';

const _locationErrorMessage =
    'Não foi possível obter sua localização. Verifique se a permissão de '
    'localização está ativada e tente novamente.';
const _cameraErrorMessage =
    'Não foi possível acessar a câmera. Verifique as permissões do '
    'aplicativo.';
const _galleryErrorMessage =
    'Não foi possível acessar a galeria. Verifique as permissões do '
    'aplicativo.';
const _submitErrorMessage =
    'Não foi possível enviar o registro. Verifique sua conexão e tente '
    'novamente.';
const _requiredFieldsErrorMessage =
    'Preencha os campos obrigatórios antes de continuar.';

class WildlifeRecordCubit extends Cubit<WildlifeRecordState> {
  WildlifeRecordCubit({
    required this.createWildlifeRecord,
    required this.uploadRecordPhoto,
    required this.getEspecies,
    required this.locationService,
    required this.mediaService,
    required this.permissionService,
  }) : super(const WildlifeRecordInitial());

  final CreateWildlifeRecord createWildlifeRecord;
  final UploadRecordPhoto uploadRecordPhoto;
  final GetEspecies getEspecies;
  final LocationService locationService;
  final MediaService mediaService;
  final PermissionService permissionService;

  Future<void> initializeForm(WildlifeRecordType type) async {
    emit(const WildlifeRecordLoadingLocation());

    final permissionResult = await permissionService
        .requestLocationPermission();
    if (permissionResult case Error()) {
      emit(const WildlifeRecordError(message: _locationErrorMessage));
      return;
    }

    final positionResult = await locationService.getCurrentPosition();
    if (positionResult case Error()) {
      emit(const WildlifeRecordError(message: _locationErrorMessage));
      return;
    }
    final position = (positionResult as Success<Position>).value;

    final especiesResult = await getEspecies(const NoParams());
    final especies = switch (especiesResult) {
      Success(value: final list) => list,
      Error() => const <Especie>[],
    };

    final now = DateTime.now();
    emit(
      WildlifeRecordFormEditing(
        draft: WildlifeRecord(
          type: type,
          dataOcorrencia: now,
          horaOcorrencia:
              '${now.hour.toString().padLeft(2, '0')}:'
              '${now.minute.toString().padLeft(2, '0')}:'
              '${now.second.toString().padLeft(2, '0')}',
          latitude: position.latitude,
          longitude: position.longitude,
          precisaoLocalizacaoM: position.accuracy,
        ),
        especies: especies,
      ),
    );
  }

  Future<void> retryLocation() async {
    final currentState = state;
    if (currentState is! WildlifeRecordFormEditing) return;

    final positionResult = await locationService.getCurrentPosition();
    switch (positionResult) {
      case Success(value: final position):
        emit(
          currentState.copyWith(
            draft: currentState.draft.copyWith(
              latitude: position.latitude,
              longitude: position.longitude,
              precisaoLocalizacaoM: position.accuracy,
            ),
          ),
        );
      case Error():
        emit(currentState.copyWith(validationError: _locationErrorMessage));
    }
  }

  void updateDraft(WildlifeRecord Function(WildlifeRecord draft) update) {
    final currentState = state;
    if (currentState is! WildlifeRecordFormEditing) return;
    emit(currentState.copyWith(draft: update(currentState.draft)));
  }

  Future<void> addPhoto({required ImageSource source}) async {
    final currentState = state;
    if (currentState is! WildlifeRecordFormEditing) return;

    final permissionResult = source == ImageSource.camera
        ? await permissionService.requestCameraPermission()
        : await permissionService.requestGalleryPermission();
    if (permissionResult case Error()) {
      emit(
        currentState.copyWith(
          validationError: source == ImageSource.camera
              ? _cameraErrorMessage
              : _galleryErrorMessage,
        ),
      );
      return;
    }

    if (source == ImageSource.camera) {
      final photoResult = await mediaService.captureFromCamera();
      if (photoResult case Success(value: final path)) {
        _appendPhoto(currentState, path);
      }
    } else {
      final photosResult = await mediaService.pickFromGallery();
      if (photosResult case Success(value: final paths)) {
        for (final path in paths) {
          _appendPhoto(state as WildlifeRecordFormEditing, path);
        }
      }
    }
  }

  void _appendPhoto(WildlifeRecordFormEditing current, String localPath) {
    final photo = RecordPhoto(localPath: localPath, tipoFoto: 'animal');
    emit(
      current.copyWith(
        draft: current.draft.copyWith(
          fotos: [...current.draft.fotos, photo],
        ),
      ),
    );
  }

  void removePhoto(int index) {
    final currentState = state;
    if (currentState is! WildlifeRecordFormEditing) return;
    final fotos = [...currentState.draft.fotos]..removeAt(index);
    emit(
      currentState.copyWith(draft: currentState.draft.copyWith(fotos: fotos)),
    );
  }

  String? _validate(WildlifeRecord draft) {
    if (draft.type == WildlifeRecordType.roadkill && draft.fotos.isEmpty) {
      return _requiredFieldsErrorMessage;
    }
    return null;
  }

  void validateAndReview() {
    final currentState = state;
    if (currentState is! WildlifeRecordFormEditing) return;

    final validationError = _validate(currentState.draft);
    if (validationError != null) {
      emit(currentState.copyWith(validationError: validationError));
      return;
    }

    emit(currentState.copyWith(isReviewing: true, validationError: null));
  }

  void backToEdit() {
    final currentState = state;
    if (currentState is! WildlifeRecordFormEditing) return;
    emit(currentState.copyWith(isReviewing: false));
  }

  Future<void> submit() async {
    final currentState = state;
    if (currentState is! WildlifeRecordFormEditing) return;

    final validationError = _validate(currentState.draft);
    if (validationError != null) {
      emit(currentState.copyWith(validationError: validationError));
      return;
    }

    var draft = currentState.draft;

    if (draft.fotos.isNotEmpty) {
      emit(const WildlifeRecordUploadingPhotos());
      final uploadedPhotos = <RecordPhoto>[];
      for (final photo in draft.fotos) {
        if (photo.localPath == null) {
          uploadedPhotos.add(photo);
          continue;
        }
        final uploadResult = await uploadRecordPhoto(
          UploadRecordPhotoParams(
            localPath: photo.localPath!,
            tipoFoto: photo.tipoFoto,
          ),
        );
        switch (uploadResult) {
          case Success(value: final uploaded):
            uploadedPhotos.add(uploaded);
          case Error():
            emit(const WildlifeRecordError(message: _submitErrorMessage));
            return;
        }
      }
      draft = draft.copyWith(fotos: uploadedPhotos);
    }

    emit(const WildlifeRecordSubmitting());
    final result = await createWildlifeRecord(
      CreateWildlifeRecordParams(record: draft),
    );
    switch (result) {
      case Success(value: final record):
        emit(WildlifeRecordSuccess(record: record));
      case Error():
        emit(const WildlifeRecordError(message: _submitErrorMessage));
    }
  }
}
