import '../../domain/entities/wildlife_record.dart';
import 'environmental_data_model.dart';
import 'record_photo_model.dart';
import 'roadkill_details_model.dart';
import 'sighting_details_model.dart';

class WildlifeRecordModel extends WildlifeRecord {
  const WildlifeRecordModel({
    super.id,
    required super.type,
    super.especieId,
    super.nomeEspecieInformado,
    required super.dataOcorrencia,
    required super.horaOcorrencia,
    required super.latitude,
    required super.longitude,
    super.precisaoLocalizacaoM,
    super.rodovia,
    super.kmRodovia,
    super.municipio,
    super.observacoes,
    super.dadosAmbientais,
    super.dadosAtropelamento,
    super.dadosAvistamento,
    super.fotos,
    super.statusValidacao,
  });

  factory WildlifeRecordModel.fromEntity(WildlifeRecord record) =>
      WildlifeRecordModel(
        id: record.id,
        type: record.type,
        especieId: record.especieId,
        nomeEspecieInformado: record.nomeEspecieInformado,
        dataOcorrencia: record.dataOcorrencia,
        horaOcorrencia: record.horaOcorrencia,
        latitude: record.latitude,
        longitude: record.longitude,
        precisaoLocalizacaoM: record.precisaoLocalizacaoM,
        rodovia: record.rodovia,
        kmRodovia: record.kmRodovia,
        municipio: record.municipio,
        observacoes: record.observacoes,
        dadosAmbientais: record.dadosAmbientais,
        dadosAtropelamento: record.dadosAtropelamento,
        dadosAvistamento: record.dadosAvistamento,
        fotos: record.fotos,
        statusValidacao: record.statusValidacao,
      );

  factory WildlifeRecordModel.fromCreateResponse(
    WildlifeRecord submitted,
    Map<String, dynamic> json,
  ) => WildlifeRecordModel(
    id: json['idRegistro'] as String,
    type: submitted.type,
    especieId: submitted.especieId,
    nomeEspecieInformado: submitted.nomeEspecieInformado,
    dataOcorrencia: submitted.dataOcorrencia,
    horaOcorrencia: submitted.horaOcorrencia,
    latitude: submitted.latitude,
    longitude: submitted.longitude,
    precisaoLocalizacaoM: submitted.precisaoLocalizacaoM,
    rodovia: submitted.rodovia,
    kmRodovia: submitted.kmRodovia,
    municipio: submitted.municipio,
    observacoes: submitted.observacoes,
    dadosAmbientais: submitted.dadosAmbientais,
    dadosAtropelamento: submitted.dadosAtropelamento,
    dadosAvistamento: submitted.dadosAvistamento,
    fotos: submitted.fotos,
    statusValidacao: json['statusValidacao'] as String? ?? 'pendente',
  );

  Map<String, dynamic> toJson() => {
    'tipoRegistro': type.apiValue,
    'idEspecie': especieId,
    'nomeEspecieInformado': nomeEspecieInformado,
    'dataOcorrencia': dataOcorrencia.toIso8601String().split('T').first,
    'horaOcorrencia': horaOcorrencia,
    'latitude': latitude,
    'longitude': longitude,
    'precisaoLocalizacaoM': precisaoLocalizacaoM,
    'rodovia': rodovia,
    'kmRodovia': kmRodovia,
    'municipio': municipio,
    'observacoes': observacoes,
    'dadosAmbientais': dadosAmbientais == null
        ? null
        : EnvironmentalDataModel.fromEntity(dadosAmbientais!).toJson(),
    'dadosAtropelamento': dadosAtropelamento == null
        ? null
        : RoadkillDetailsModel.fromEntity(dadosAtropelamento!).toJson(),
    'dadosAvistamento': dadosAvistamento == null
        ? null
        : SightingDetailsModel.fromEntity(dadosAvistamento!).toJson(),
    'fotos': fotos.map((f) => RecordPhotoModel.fromEntity(f).toJson()).toList(),
  };
}
