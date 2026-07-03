import 'package:equatable/equatable.dart';

import 'environmental_data.dart';
import 'record_photo.dart';
import 'roadkill_details.dart';
import 'sighting_details.dart';
import 'wildlife_record_sync_status.dart';
import 'wildlife_record_type.dart';

class WildlifeRecord extends Equatable {
  const WildlifeRecord({
    this.id,
    required this.type,
    this.especieId,
    this.nomeEspecieInformado,
    required this.dataOcorrencia,
    required this.horaOcorrencia,
    required this.latitude,
    required this.longitude,
    this.precisaoLocalizacaoM,
    this.rodovia,
    this.kmRodovia,
    this.municipio,
    this.observacoes,
    this.dadosAmbientais,
    this.dadosAtropelamento,
    this.dadosAvistamento,
    this.fotos = const [],
    this.statusValidacao = 'pendente',
    this.syncStatus = WildlifeRecordSyncStatus.pending,
    this.remoteId,
  });

  final String? id;
  final WildlifeRecordType type;
  final String? especieId;
  final String? nomeEspecieInformado;
  final DateTime dataOcorrencia;
  final String horaOcorrencia;
  final double latitude;
  final double longitude;
  final double? precisaoLocalizacaoM;
  final String? rodovia;
  final double? kmRodovia;
  final String? municipio;
  final String? observacoes;
  final EnvironmentalData? dadosAmbientais;
  final RoadkillDetails? dadosAtropelamento;
  final SightingDetails? dadosAvistamento;
  final List<RecordPhoto> fotos;
  final String statusValidacao;

  /// Local persistence sync state — distinct from [statusValidacao], which is
  /// the business validation status returned/owned by the backend.
  final WildlifeRecordSyncStatus syncStatus;

  /// Server-assigned id once synced. [id] stays the stable local identity —
  /// it must never be overwritten by the remote id, since local rows
  /// ([RecordPhoto] etc.) key off it.
  final String? remoteId;

  WildlifeRecord copyWith({
    String? id,
    WildlifeRecordType? type,
    String? especieId,
    String? nomeEspecieInformado,
    DateTime? dataOcorrencia,
    String? horaOcorrencia,
    double? latitude,
    double? longitude,
    double? precisaoLocalizacaoM,
    String? rodovia,
    double? kmRodovia,
    String? municipio,
    String? observacoes,
    EnvironmentalData? dadosAmbientais,
    RoadkillDetails? dadosAtropelamento,
    SightingDetails? dadosAvistamento,
    List<RecordPhoto>? fotos,
    String? statusValidacao,
    WildlifeRecordSyncStatus? syncStatus,
    String? remoteId,
  }) {
    return WildlifeRecord(
      id: id ?? this.id,
      type: type ?? this.type,
      especieId: especieId ?? this.especieId,
      nomeEspecieInformado: nomeEspecieInformado ?? this.nomeEspecieInformado,
      dataOcorrencia: dataOcorrencia ?? this.dataOcorrencia,
      horaOcorrencia: horaOcorrencia ?? this.horaOcorrencia,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      precisaoLocalizacaoM: precisaoLocalizacaoM ?? this.precisaoLocalizacaoM,
      rodovia: rodovia ?? this.rodovia,
      kmRodovia: kmRodovia ?? this.kmRodovia,
      municipio: municipio ?? this.municipio,
      observacoes: observacoes ?? this.observacoes,
      dadosAmbientais: dadosAmbientais ?? this.dadosAmbientais,
      dadosAtropelamento: dadosAtropelamento ?? this.dadosAtropelamento,
      dadosAvistamento: dadosAvistamento ?? this.dadosAvistamento,
      fotos: fotos ?? this.fotos,
      statusValidacao: statusValidacao ?? this.statusValidacao,
      syncStatus: syncStatus ?? this.syncStatus,
      remoteId: remoteId ?? this.remoteId,
    );
  }

  @override
  List<Object?> get props => [
    id,
    type,
    especieId,
    nomeEspecieInformado,
    dataOcorrencia,
    horaOcorrencia,
    latitude,
    longitude,
    precisaoLocalizacaoM,
    rodovia,
    kmRodovia,
    municipio,
    observacoes,
    dadosAmbientais,
    dadosAtropelamento,
    dadosAvistamento,
    fotos,
    statusValidacao,
    syncStatus,
    remoteId,
  ];
}
