import 'package:flutter/material.dart';

class LocationSection extends StatelessWidget {
  const LocationSection({
    super.key,
    required this.latitude,
    required this.longitude,
    this.precisaoLocalizacaoM,
    required this.onRetry,
  });

  final double latitude;
  final double longitude;
  final double? precisaoLocalizacaoM;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Localização', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.location_on, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Lat: ${latitude.toStringAsFixed(6)}, '
                'Lng: ${longitude.toStringAsFixed(6)}'
                '${precisaoLocalizacaoM != null ? ' (±${precisaoLocalizacaoM!.toStringAsFixed(1)}m)' : ''}',
              ),
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: onRetry,
              tooltip: 'Atualizar localização',
            ),
          ],
        ),
      ],
    );
  }
}
