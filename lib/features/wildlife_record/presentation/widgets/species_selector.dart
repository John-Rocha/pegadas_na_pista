import 'package:flutter/material.dart';

import '../../domain/entities/especie.dart';

class SpeciesSelector extends StatelessWidget {
  const SpeciesSelector({
    super.key,
    required this.especies,
    required this.especieId,
    required this.nomeEspecieInformado,
    required this.onEspecieIdChanged,
    required this.onNomeInformadoChanged,
  });

  final List<Especie> especies;
  final String? especieId;
  final String? nomeEspecieInformado;
  final ValueChanged<String?> onEspecieIdChanged;
  final ValueChanged<String> onNomeInformadoChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Espécie', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        if (especies.isNotEmpty)
          DropdownButtonFormField<String>(
            initialValue: especieId,
            decoration: const InputDecoration(
              labelText: 'Espécie cadastrada',
            ),
            items: especies
                .map(
                  (especie) => DropdownMenuItem(
                    value: especie.idEspecie,
                    child: Text(especie.nomePopular ?? especie.idEspecie),
                  ),
                )
                .toList(),
            onChanged: onEspecieIdChanged,
          ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: nomeEspecieInformado,
          decoration: const InputDecoration(
            labelText: 'Nome aproximado (opcional)',
          ),
          onChanged: onNomeInformadoChanged,
        ),
      ],
    );
  }
}
