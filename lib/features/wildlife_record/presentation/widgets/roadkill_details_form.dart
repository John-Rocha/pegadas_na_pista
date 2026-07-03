import 'package:flutter/material.dart';

import '../../domain/entities/roadkill_details.dart';

class RoadkillDetailsForm extends StatelessWidget {
  const RoadkillDetailsForm({
    super.key,
    required this.details,
    required this.rodovia,
    required this.kmRodovia,
    required this.municipio,
    required this.onDetailsChanged,
    required this.onRodoviaChanged,
    required this.onKmRodoviaChanged,
    required this.onMunicipioChanged,
  });

  final RoadkillDetails details;
  final String? rodovia;
  final double? kmRodovia;
  final String? municipio;
  final ValueChanged<RoadkillDetails> onDetailsChanged;
  final ValueChanged<String> onRodoviaChanged;
  final ValueChanged<double?> onKmRodoviaChanged;
  final ValueChanged<String> onMunicipioChanged;

  static const carcassConditionOptions = [
    'inteira',
    'parcial',
    'decomposta',
    'nao_identificavel',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dados do atropelamento',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: details.carcassCondition,
          decoration: const InputDecoration(
            labelText: 'Condição da carcaça',
          ),
          items: carcassConditionOptions
              .map(
                (option) =>
                    DropdownMenuItem(value: option, child: Text(option)),
              )
              .toList(),
          onChanged: (value) => onDetailsChanged(
            RoadkillDetails(
              carcassCondition: value,
              animalPosition: details.animalPosition,
              roadDirection: details.roadDirection,
              roadLane: details.roadLane,
            ),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: details.animalPosition,
          decoration: const InputDecoration(labelText: 'Posição do animal'),
          onChanged: (value) => onDetailsChanged(
            RoadkillDetails(
              carcassCondition: details.carcassCondition,
              animalPosition: value,
              roadDirection: details.roadDirection,
              roadLane: details.roadLane,
            ),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: details.roadDirection,
          decoration: const InputDecoration(labelText: 'Sentido da via'),
          onChanged: (value) => onDetailsChanged(
            RoadkillDetails(
              carcassCondition: details.carcassCondition,
              animalPosition: details.animalPosition,
              roadDirection: value,
              roadLane: details.roadLane,
            ),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: details.roadLane,
          decoration: const InputDecoration(labelText: 'Faixa da rodovia'),
          onChanged: (value) => onDetailsChanged(
            RoadkillDetails(
              carcassCondition: details.carcassCondition,
              animalPosition: details.animalPosition,
              roadDirection: details.roadDirection,
              roadLane: value,
            ),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: rodovia,
          decoration: const InputDecoration(labelText: 'Rodovia'),
          onChanged: onRodoviaChanged,
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: kmRodovia?.toString(),
          decoration: const InputDecoration(labelText: 'Quilômetro aproximado'),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: (value) => onKmRodoviaChanged(double.tryParse(value)),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: municipio,
          decoration: const InputDecoration(labelText: 'Município'),
          onChanged: onMunicipioChanged,
        ),
      ],
    );
  }
}
