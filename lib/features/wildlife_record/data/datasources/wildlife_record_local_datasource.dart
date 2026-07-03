import '../../../../core/database/database_helper.dart';
import '../models/record_photo_model.dart';
import '../models/wildlife_record_model.dart';

abstract class WildlifeRecordLocalDataSource {
  Future<Map<String, dynamic>> createRecord(WildlifeRecordModel record);

  Future<RecordPhotoModel> uploadPhoto({
    required String localPath,
    required String tipoFoto,
    String? registroId,
  });
}

class WildlifeRecordLocalDataSourceImpl
    implements WildlifeRecordLocalDataSource {
  WildlifeRecordLocalDataSourceImpl({required this.databaseHelper});

  final DatabaseHelper databaseHelper;

  @override
  Future<Map<String, dynamic>> createRecord(
    WildlifeRecordModel record,
  ) async {
    final db = await databaseHelper.database;
    final id = DateTime.now().microsecondsSinceEpoch.toString();

    await db.transaction((txn) async {
      await txn.insert('wildlife_records', {
        'id': id,
        'tipo_registro': record.type.apiValue,
        'id_especie': record.especieId,
        'nome_especie_informado': record.nomeEspecieInformado,
        'data_ocorrencia': record.dataOcorrencia
            .toIso8601String()
            .split(
              'T',
            )
            .first,
        'hora_ocorrencia': record.horaOcorrencia,
        'latitude': record.latitude,
        'longitude': record.longitude,
        'precisao_localizacao_m': record.precisaoLocalizacaoM,
        'rodovia': record.rodovia,
        'km_rodovia': record.kmRodovia,
        'municipio': record.municipio,
        'observacoes': record.observacoes,
        'status_validacao': 'pendente',
        'sync_status': record.syncStatus.name,
        'remote_id': record.remoteId,
        'created_at': DateTime.now().toIso8601String(),
      });

      final dadosAmbientais = record.dadosAmbientais;
      if (dadosAmbientais != null) {
        await txn.insert('wildlife_record_environmental_data', {
          'record_id': id,
          'clima': dadosAmbientais.weather,
          'periodo_dia': dadosAmbientais.dayPeriod,
          'temperatura_c': dadosAmbientais.temperature,
          'umidade_percentual': dadosAmbientais.humidity,
          'precipitacao_mm': dadosAmbientais.precipitation,
          'condicao_pista': dadosAmbientais.roadCondition,
          'luminosidade': dadosAmbientais.luminosity,
          'visibilidade': dadosAmbientais.visibility,
          'observacao_ambiental': dadosAmbientais.notes,
        });
      }

      final dadosAtropelamento = record.dadosAtropelamento;
      if (dadosAtropelamento != null) {
        await txn.insert('wildlife_record_roadkill_details', {
          'record_id': id,
          'condicao_carcaca': dadosAtropelamento.carcassCondition,
          'posicao_animal': dadosAtropelamento.animalPosition,
          'sentido_via': dadosAtropelamento.roadDirection,
          'faixa_rodovia': dadosAtropelamento.roadLane,
        });
      }

      final dadosAvistamento = record.dadosAvistamento;
      if (dadosAvistamento != null) {
        await txn.insert('wildlife_record_sighting_details', {
          'record_id': id,
          'quantidade_individuos': dadosAvistamento.quantity,
          'comportamento_observado': dadosAvistamento.observedBehavior,
          'distancia_aproximada_m': dadosAvistamento.approximateDistance,
          'animal_vivo': dadosAvistamento.animalAlive ? 1 : 0,
        });
      }

      for (final foto in record.fotos) {
        await txn.insert('wildlife_record_photos', {
          'record_id': id,
          'local_path': foto.localPath,
          'url_foto': foto.urlFoto,
          'tipo_foto': foto.tipoFoto,
          'ordem': foto.ordem,
        });
      }
    });

    return {'idRegistro': id, 'statusValidacao': 'pendente'};
  }

  @override
  Future<RecordPhotoModel> uploadPhoto({
    required String localPath,
    required String tipoFoto,
    String? registroId,
  }) async {
    return RecordPhotoModel(localPath: localPath, tipoFoto: tipoFoto);
  }
}
