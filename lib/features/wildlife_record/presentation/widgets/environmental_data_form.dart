import 'package:flutter/material.dart';

import '../../domain/entities/environmental_data.dart';

class EnvironmentalDataForm extends StatelessWidget {
  const EnvironmentalDataForm({
    super.key,
    required this.data,
    required this.onChanged,
  });

  final EnvironmentalData data;
  final ValueChanged<EnvironmentalData> onChanged;

  static const climaOptions = [
    'ensolarado',
    'nublado',
    'chuvoso',
    'neblina',
    'nao_informado',
  ];
  static const periodoDiaOptions = ['manha', 'tarde', 'noite', 'madrugada'];
  static const condicaoPistaOptions = [
    'seca',
    'molhada',
    'alagada',
    'com_barro',
    'nao_informado',
  ];
  static const luminosidadeOptions = ['claro', 'escuro', 'nao_informado'];
  static const visibilidadeOptions = [
    'boa',
    'moderada',
    'ruim',
    'nao_informado',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Condições ambientais',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        _dropdown(
          label: 'Clima',
          value: data.weather,
          options: climaOptions,
          onChanged: (value) => onChanged(_copy(weather: value)),
        ),
        _dropdown(
          label: 'Período do dia',
          value: data.dayPeriod,
          options: periodoDiaOptions,
          onChanged: (value) => onChanged(_copy(dayPeriod: value)),
        ),
        _dropdown(
          label: 'Condição da pista',
          value: data.roadCondition,
          options: condicaoPistaOptions,
          onChanged: (value) => onChanged(_copy(roadCondition: value)),
        ),
        _dropdown(
          label: 'Luminosidade',
          value: data.luminosity,
          options: luminosidadeOptions,
          onChanged: (value) => onChanged(_copy(luminosity: value)),
        ),
        _dropdown(
          label: 'Visibilidade',
          value: data.visibility,
          options: visibilidadeOptions,
          onChanged: (value) => onChanged(_copy(visibility: value)),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: data.notes,
          decoration: const InputDecoration(
            labelText: 'Observação ambiental (opcional)',
          ),
          onChanged: (value) => onChanged(_copy(notes: value)),
        ),
      ],
    );
  }

  EnvironmentalData _copy({
    String? weather,
    String? dayPeriod,
    String? roadCondition,
    String? luminosity,
    String? visibility,
    String? notes,
  }) {
    return EnvironmentalData(
      weather: weather ?? data.weather,
      dayPeriod: dayPeriod ?? data.dayPeriod,
      temperature: data.temperature,
      humidity: data.humidity,
      precipitation: data.precipitation,
      roadCondition: roadCondition ?? data.roadCondition,
      luminosity: luminosity ?? data.luminosity,
      visibility: visibility ?? data.visibility,
      notes: notes ?? data.notes,
    );
  }

  Widget _dropdown({
    required String label,
    required String? value,
    required List<String> options,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: DropdownButtonFormField<String>(
        initialValue: value,
        decoration: InputDecoration(labelText: label),
        items: options
            .map(
              (option) => DropdownMenuItem(value: option, child: Text(option)),
            )
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}
