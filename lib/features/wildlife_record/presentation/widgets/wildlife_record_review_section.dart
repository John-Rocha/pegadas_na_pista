import 'package:flutter/material.dart';

import '../../domain/entities/wildlife_record.dart';
import '../../domain/entities/wildlife_record_type.dart';

class WildlifeRecordReviewSection extends StatelessWidget {
  const WildlifeRecordReviewSection({
    super.key,
    required this.draft,
    required this.onEdit,
    required this.onSubmit,
  });

  final WildlifeRecord draft;
  final VoidCallback onEdit;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final isRoadkill = draft.type == WildlifeRecordType.roadkill;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Revisar registro',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          _section(
            context,
            'Tipo',
            isRoadkill ? 'Atropelamento' : 'Avistamento',
          ),
          _section(
            context,
            'Espécie',
            draft.especieId ?? draft.nomeEspecieInformado ?? 'Não identificada',
          ),
          _section(
            context,
            'Data e hora',
            '${draft.dataOcorrencia.toLocal().toString().split(' ').first} '
                '${draft.horaOcorrencia}',
          ),
          _section(
            context,
            'Localização',
            'Lat: ${draft.latitude.toStringAsFixed(6)}, '
                'Lng: ${draft.longitude.toStringAsFixed(6)}',
          ),
          if (draft.rodovia != null || draft.municipio != null)
            _section(
              context,
              'Rodovia',
              [
                draft.rodovia,
                if (draft.kmRodovia != null) 'km ${draft.kmRodovia}',
                draft.municipio,
              ].whereType<String>().join(' — '),
            ),
          if (draft.dadosAmbientais != null)
            _section(
              context,
              'Condições ambientais',
              [
                draft.dadosAmbientais?.weather,
                draft.dadosAmbientais?.dayPeriod,
                draft.dadosAmbientais?.roadCondition,
              ].whereType<String>().join(' — '),
            ),
          if (isRoadkill && draft.dadosAtropelamento != null)
            _section(
              context,
              'Dados do atropelamento',
              [
                draft.dadosAtropelamento?.carcassCondition,
                draft.dadosAtropelamento?.animalPosition,
              ].whereType<String>().join(' — '),
            ),
          if (!isRoadkill && draft.dadosAvistamento != null)
            _section(
              context,
              'Dados do avistamento',
              'Quantidade: ${draft.dadosAvistamento?.quantity}, '
                  'Vivo: ${draft.dadosAvistamento?.animalAlive == true ? "Sim" : "Não"}',
            ),
          _section(context, 'Fotos', '${draft.fotos.length} anexada(s)'),
          if (draft.observacoes != null && draft.observacoes!.isNotEmpty)
            _section(context, 'Observações', draft.observacoes!),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onEdit,
                  child: const Text('Editar'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: onSubmit,
                  child: const Text('Enviar'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _section(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }
}
