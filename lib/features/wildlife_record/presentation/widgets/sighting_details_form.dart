import 'package:flutter/material.dart';

import '../../domain/entities/sighting_details.dart';

class SightingDetailsForm extends StatelessWidget {
  const SightingDetailsForm({
    super.key,
    required this.details,
    required this.onChanged,
  });

  final SightingDetails details;
  final ValueChanged<SightingDetails> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dados do avistamento',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: details.quantity.toString(),
          decoration: const InputDecoration(
            labelText: 'Quantidade de indivíduos',
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) => onChanged(
            SightingDetails(
              quantity: int.tryParse(value) ?? details.quantity,
              observedBehavior: details.observedBehavior,
              approximateDistance: details.approximateDistance,
              animalAlive: details.animalAlive,
            ),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: details.observedBehavior,
          decoration: const InputDecoration(
            labelText: 'Comportamento observado',
          ),
          onChanged: (value) => onChanged(
            SightingDetails(
              quantity: details.quantity,
              observedBehavior: value,
              approximateDistance: details.approximateDistance,
              animalAlive: details.animalAlive,
            ),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: details.approximateDistance?.toString(),
          decoration: const InputDecoration(
            labelText: 'Distância aproximada (m)',
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: (value) => onChanged(
            SightingDetails(
              quantity: details.quantity,
              observedBehavior: details.observedBehavior,
              approximateDistance:
                  double.tryParse(value) ?? details.approximateDistance,
              animalAlive: details.animalAlive,
            ),
          ),
        ),
        const SizedBox(height: 8),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Animal vivo'),
          value: details.animalAlive,
          onChanged: (value) => onChanged(
            SightingDetails(
              quantity: details.quantity,
              observedBehavior: details.observedBehavior,
              approximateDistance: details.approximateDistance,
              animalAlive: value,
            ),
          ),
        ),
      ],
    );
  }
}
