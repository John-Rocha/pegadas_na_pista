import 'package:flutter/material.dart';

import '../../domain/entities/wildlife_record_type.dart';

class RecordTypeSelector extends StatelessWidget {
  const RecordTypeSelector({super.key, required this.onSelected});

  final ValueChanged<WildlifeRecordType> onSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Tipo de registro',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => onSelected(WildlifeRecordType.roadkill),
            icon: const Icon(Icons.report),
            label: const Text('Atropelamento'),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => onSelected(WildlifeRecordType.sighting),
            icon: const Icon(Icons.visibility),
            label: const Text('Avistamento'),
          ),
        ],
      ),
    );
  }
}
