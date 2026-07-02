import '../../domain/entities/record_photo.dart';

class RecordPhotoModel extends RecordPhoto {
  const RecordPhotoModel({
    super.localPath,
    super.urlFoto,
    required super.tipoFoto,
    super.ordem,
  });

  factory RecordPhotoModel.fromEntity(RecordPhoto photo) => RecordPhotoModel(
    localPath: photo.localPath,
    urlFoto: photo.urlFoto,
    tipoFoto: photo.tipoFoto,
    ordem: photo.ordem,
  );

  factory RecordPhotoModel.fromJson(Map<String, dynamic> json) =>
      RecordPhotoModel(
        urlFoto: json['urlFoto'] as String,
        tipoFoto: json['tipoFoto'] as String? ?? 'animal',
        ordem: json['ordem'] as int? ?? 1,
      );

  Map<String, dynamic> toJson() => {
    'urlFoto': urlFoto,
    'tipoFoto': tipoFoto,
    'ordem': ordem,
  };
}
